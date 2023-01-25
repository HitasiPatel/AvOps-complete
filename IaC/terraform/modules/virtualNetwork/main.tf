locals {
  resource_type = "vnet"
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "${local.resource_type}-${var.vnet_name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.address_space]
  tags                = var.tags
}
