data "azurerm_client_config" "current" {}

locals {
  resource_type = "kv"
}

resource "azurerm_key_vault" "kv" {
  name                = "${local.resource_type}-${var.key_vault_name}-${var.kv_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.kv_sku_name
  tags                = var.tags

  network_acls {
    virtual_network_subnet_ids = [var.subnet_id]
    default_action             = "Allow"
    bypass                     = "AzureServices"
  }
}

resource "azurerm_private_endpoint" "kv-private-endpoint" {
  name                = "${local.resource_type}-${var.key_vault_name}-private-endpoint"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "${local.resource_type}-${var.key_vault_name}-private-service-connection"
    private_connection_resource_id = azurerm_key_vault.kv.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [var.vault_core_dns_zone_id]
  }
}
