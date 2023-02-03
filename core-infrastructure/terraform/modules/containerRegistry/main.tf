locals {
  resource_type = "acr"
}

resource "azurerm_container_registry" "acr" {
  name                = "${local.resource_type}${var.acr_name}${var.acr_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.acr_sku
  admin_enabled       = false
  tags                = var.tags
  identity {
    type = "SystemAssigned"
  }
}
