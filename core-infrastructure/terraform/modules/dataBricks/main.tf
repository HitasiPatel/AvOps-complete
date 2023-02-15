locals {
  databricks_resource_type = "databricks"
  nsg_resource_type        = "nsg"
}

resource "azurerm_network_security_group" "databricks_nsg" {
  name                = "${local.nsg_resource_type}-${local.databricks_resource_type}-${var.databricks_name}-${var.tags.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_network_security_group_association" "databricks_nsg_host_subnet_association" {
  depends_on = [
    azurerm_network_security_group.databricks_nsg
  ]
  subnet_id                 = var.host_subnet_id
  network_security_group_id = azurerm_network_security_group.databricks_nsg.id
}

resource "azurerm_subnet_network_security_group_association" "databricks_nsg_container_subnet_association" {
  depends_on = [
    azurerm_network_security_group.databricks_nsg
  ]
  subnet_id                 = var.container_subnet_id
  network_security_group_id = azurerm_network_security_group.databricks_nsg.id
}

resource "azurerm_databricks_workspace" "databricks_workspace" {
  name                = "${local.databricks_resource_type}-${var.databricks_name}-${var.databricks_suffix}-${var.tags.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  tags                = var.tags
  custom_parameters {
    virtual_network_id                                   = var.virtual_network_id
    private_subnet_name                                  = var.container_subnet_name
    public_subnet_name                                   = var.host_subnet_name
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.databricks_nsg_container_subnet_association.id
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.databricks_nsg_host_subnet_association.id
  }
}

