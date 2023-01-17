data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                = "${var.key_vault_name}-${var.kv_suffix}-${var.tags.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.kv_sku_name
  tags = var.tags

  network_acls {
    virtual_network_subnet_ids = [var.subnet_id]
    default_action             = "Allow"
    bypass                     = "AzureServices"
  }
}
