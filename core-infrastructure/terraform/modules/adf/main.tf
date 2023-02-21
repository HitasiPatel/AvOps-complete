locals {
  environment                        = var.tags["environment"]
  resource_type                      = "adf"
  adf_integration_runtime_azure_name = "IntegrationRuntime"
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