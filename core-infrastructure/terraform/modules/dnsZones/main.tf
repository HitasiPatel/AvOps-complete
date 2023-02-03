locals {
  # These zone names are recommended per Azure Docs:
  # https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-dns#azure-services-dns-zone-configuration
  dns_storage_blob_private_link = "privatelink.blob.core.windows.net"
  dns_vault_core_private_link   = "privatelink.vaultcore.azure.net"
  dns_adf_private_link          = "privatelink.datafactory.azure.net"
  dns_batch_private_link        = "privatelink.batch.azure.com"
  dns_mongo_cosmos_private_link = "privatelink.mongo.cosmos.azure.com"
  dns_app_service_private_link  = "privatelink.azurewebsites.net"
}

resource "azurerm_private_dns_zone" "blob_privatelink" {
  name                = local.dns_storage_blob_private_link
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone" "vault_core_private_link" {
  name                = local.dns_vault_core_private_link
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone" "adf_private_link" {
  name                = local.dns_adf_private_link
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone" "batch_private_link" {
  name                = local.dns_batch_private_link
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone" "mongo_cosmos_private_link" {
  name                = local.dns_mongo_cosmos_private_link
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone" "app_service_private_link" {
  name                = local.dns_app_service_private_link
  resource_group_name = var.resource_group_name
}