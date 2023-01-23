locals {
  resource_type = "subnet"
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.subnet_name}-${local.resource_type}"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [var.address_prefix]
  service_endpoints    = var.service_endpoints
}
