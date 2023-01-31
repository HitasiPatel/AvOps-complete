locals {
  environment                        = var.tags["environment"]
  resource_type                      = "adf"
  keyvault_link_service_name         = "LS_KeyVault"
  batch_storage_link_service_name    = "LS_BatchStorage"
  batch_link_service_name            = "LS_Batch"
  batch_link_service_type            = "AzureBatch"
  storage_account_prefix             = "av"
  adls_linked_service_prefix         = "LS"
  adf_integration_runtime_azure_name = "IntegrationRuntime"
  approve_managed_ep_script_path     = "../modules/adf/approve_managed_endpoints.sh"
}

resource "azurerm_data_factory" "data_factory" {
  name                            = "${local.resource_type}-${var.adf_name}-${var.adf_suffix}"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  managed_virtual_network_enabled = var.managed_virtual_network_enabled
  tags                            = var.tags
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_private_endpoint" "adf-private-endpoint" {
  name                = "${local.resource_type}-${var.adf_name}-private-endpoint"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${local.resource_type}-${var.adf_name}-private-service-connection"
    private_connection_resource_id = azurerm_data_factory.data_factory.id
    subresource_names              = ["dataFactory"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.adf_dns_zone_id]
  }
}

resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "linked_service_storage" {
  for_each                 = var.adls_storage_accounts
  name                     = "${local.adls_linked_service_prefix}_${title(split(local.storage_account_prefix, split(local.environment, each.value.name)[0])[1])}"
  data_factory_id          = azurerm_data_factory.data_factory.id
  integration_runtime_name = azurerm_data_factory_integration_runtime_azure.managed_integeration_runtime.name
  url                      = each.value.primary_dfs_endpoint
  use_managed_identity     = true
}

resource "azurerm_data_factory_linked_service_key_vault" "key_vault_linked_service" {
  name                     = local.keyvault_link_service_name
  data_factory_id          = azurerm_data_factory.data_factory.id
  key_vault_id             = var.key_vault_id
  integration_runtime_name = azurerm_data_factory_integration_runtime_azure.managed_integeration_runtime.name

  depends_on = [
    azurerm_data_factory_managed_private_endpoint.keyvault_managed_private_endpoint
  ]
}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "batch_storage_linked_service" {
  name                     = local.batch_storage_link_service_name
  data_factory_id          = azurerm_data_factory.data_factory.id
  connection_string        = var.batch_storage_account_connection_string
  integration_runtime_name = azurerm_data_factory_integration_runtime_azure.managed_integeration_runtime.name
}

resource "azurerm_data_factory_linked_custom_service" "batch_linked_service" {
  name                 = local.batch_link_service_name
  data_factory_id      = azurerm_data_factory.data_factory.id
  type                 = local.batch_link_service_type
  type_properties_json = <<JSON
{
  "batchUri": "https://${var.batch_account_endpoint}",
  "poolName": "${var.batch_account_exec_pool_name}",
  "accountName": "${var.batch_account_name}",
  "linkedServiceName": {
    "referenceName": "${local.batch_storage_link_service_name}",
    "type": "LinkedServiceReference"
  }
}
JSON

  depends_on = [
    azurerm_data_factory_linked_service_azure_blob_storage.batch_storage_linked_service
  ]
}

resource "azurerm_data_factory_integration_runtime_azure" "managed_integeration_runtime" {
  name                    = local.adf_integration_runtime_azure_name
  data_factory_id         = azurerm_data_factory.data_factory.id
  location                = var.location
  description             = "Managed Azure hosted intergartion runtime"
  compute_type            = "General"
  core_count              = 8
  time_to_live_min        = 10
  cleanup_enabled         = false
  virtual_network_enabled = true
}

resource "azurerm_data_factory_managed_private_endpoint" "keyvault_managed_private_endpoint" {
  name               = "${var.key_vault_name}-managed-private-endpoint"
  data_factory_id    = azurerm_data_factory.data_factory.id
  target_resource_id = var.key_vault_id
  subresource_name   = "vault"
}

resource "azurerm_data_factory_managed_private_endpoint" "app_service_managed_private_endpoint" {
  name               = "${var.app_service_name}-managed-private-endpoint"
  data_factory_id    = azurerm_data_factory.data_factory.id
  target_resource_id = var.app_service_id
  subresource_name   = "sites"
}


resource "null_resource" "approve_managed_endpoint" {
  depends_on = [
    azurerm_data_factory_managed_private_endpoint.app_service_managed_private_endpoint,
    azurerm_data_factory_managed_private_endpoint.keyvault_managed_private_endpoint
  ]
  provisioner "local-exec" {
    command = "chmod +x ${local.approve_managed_ep_script_path};  ${local.approve_managed_ep_script_path} ${var.resource_group_name} ${var.key_vault_name} ${var.app_service_name} ${azurerm_data_factory_managed_private_endpoint.keyvault_managed_private_endpoint.name} ${azurerm_data_factory_managed_private_endpoint.app_service_managed_private_endpoint.name}"
  }
}