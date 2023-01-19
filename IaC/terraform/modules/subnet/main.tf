resource "azurerm_subnet" "subnet" {
  name                 = "${var.virtual_network_name}-${var.subnet_name}-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [var.address_prefix]
  service_endpoints    = var.service_endpoints
}
