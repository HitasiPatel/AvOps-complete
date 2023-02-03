terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.39.0"
    }
  }
}

locals {

  # For loop takes storage accounts and creates map of  
  # key -> storage account name
  # value -> replication type

  storage_account_map = {
    for storage_account, containers in var.storage_account_container_config :
    split(":", "${storage_account}")[0] => split(":", "${storage_account}")[1]
  }


  # 1st for loop takes storage accounts
  # 2nd for loop takes containers from the storage account selected in first for loop and prepares a map of
  # key -> storage account name : storage account replication type : container name
  # value -> container name

  container_config = merge([
    for storage_account, containers in var.storage_account_container_config : {
      for containername, container_lifecycle_config in containers :
        "${storage_account}:${containername}" => containername
    }
  ]...)

  blob_type_blockblob      = "blockBlob"
  lifecycle_action_cool    = "cool"
  lifecycle_action_archive = "archive"
  lifecycle_action_delete  = "delete"
}

# Looping and creating multiple stoarge accounts based on the 
# keys and values of var.storage_account_map

resource "azurerm_storage_account" "storage_account" {
  for_each                 = local.storage_account_map
  name                     = "${each.key}${var.adls_suffix}${var.tags.environment}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = each.value
  account_kind             = var.account_kind
  is_hns_enabled           = var.is_hns_enabled
  nfsv3_enabled            = var.nfsv3_enabled
  tags                     = var.tags
  blob_properties {
    last_access_time_enabled = var.last_access_time_enabled

    cors_rule {
      allowed_headers    = ["*"]
      allowed_methods    = ["GET", "HEAD", "OPTIONS"]
      allowed_origins    = var.blob_storage_cors_origins
      exposed_headers    = ["*"]
      max_age_in_seconds = 0
    }
  }
  network_rules {
    default_action             = var.default_action
    bypass                     = var.bypass
    virtual_network_subnet_ids = var.network_rules_subnet_ids
  }
}

# Looping over the container_list and creating containers in 
# respective storage accounts.

# The azurerm_storage_container resource block can not be used due to a bug in the terraform provider 
# Hence the deployment is done using ARM template for storage containers

resource "azurerm_resource_group_template_deployment" "storage-containers" {
  for_each            = local.container_config
  name                = "${each.value}-deploy"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"

  depends_on = [
    azurerm_storage_account.storage_account
  ]

  parameters_content = jsonencode({
    "location"             = { value = var.location }
    "storageAccountName"   = { value = join("", [split(":", "${each.key}")[0], var.adls_suffix, var.tags.environment]) }
    "defaultContainerName" = { value = "${each.value}" }
    "storageAccountSku"    = { value = join("_", [var.account_tier, split(":", "${each.key}")[1]]) }
  })

  template_content = file("${path.module}/storage-container.json")
}

locals {
  storage_name_id_map = zipmap(values(azurerm_storage_account.storage_account)[*].name, values(azurerm_storage_account.storage_account)[*].id)
}

resource "azurerm_private_endpoint" "storage-private-endpoint" {
  for_each            = azurerm_storage_account.storage_account
  name                = "${each.value.name}-private-endpoint"
  resource_group_name = var.resource_group_name
  location            = var.location
  subnet_id           = var.private_link_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "${each.value.name}-private-service-connection"
    private_connection_resource_id = each.value.id
    subresource_names              = ["blob"]
    is_manual_connection           = var.is_manual_connection
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.blob_storage_dns_zone_id]
  }
}

resource "azurerm_storage_management_policy" "lifecycle" {
  for_each           = var.storage_account_container_config
  storage_account_id = local.storage_name_id_map[join("", [split(":", "${each.key}")[0], "${var.adls_suffix}", "${var.tags.environment}"])]
  dynamic "rule" {
    for_each = { for key, value in "${each.value}" : key => value if can(value[local.lifecycle_action_cool]) }
    content {
      name    = rule.key
      enabled = true
      filters {
        prefix_match = [rule.key]
        blob_types   = [local.blob_type_blockblob]
      }
      actions {
        base_blob {
          tier_to_cool_after_days_since_modification_greater_than = rule.value[local.lifecycle_action_cool]
        }
      }
    }
  }
  dynamic "rule" {
    for_each = { for key, value in "${each.value}" : key => value if can(value[local.lifecycle_action_archive]) }
    content {
      name    = rule.key
      enabled = true
      filters {
        prefix_match = [rule.key]
        blob_types   = [local.blob_type_blockblob]
      }
      actions {
        base_blob {
          tier_to_archive_after_days_since_modification_greater_than = rule.value[local.lifecycle_action_archive]
        }
      }
    }
  }
  dynamic "rule" {
    for_each = { for key, value in "${each.value}" : key => value if can(value[local.lifecycle_action_delete]) }
    content {
      name    = rule.key
      enabled = true
      filters {
        prefix_match = [rule.key]
        blob_types   = [local.blob_type_blockblob]
      }
      actions {
        base_blob {
          delete_after_days_since_modification_greater_than = rule.value[local.lifecycle_action_delete]
        }
      }
    }
  }
}
