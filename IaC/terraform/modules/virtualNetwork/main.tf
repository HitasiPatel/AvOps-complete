resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.vnet_name}-${var.tags.environment}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.address_space]
  tags                = var.tags
}
