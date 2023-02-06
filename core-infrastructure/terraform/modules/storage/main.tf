locals {
  resource_type = "batch"
}

resource "azurerm_storage_account" "batch_storage" {
  name                     = "${local.resource_type}${var.storage_account_name}${var.storage_suffix}${var.tags.environment}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind             = var.account_kind
  tags                     = var.tags
  network_rules {
    default_action            = var.default_action
    virtual_network_subnet_ids = [var.subnet_id]
  }
}