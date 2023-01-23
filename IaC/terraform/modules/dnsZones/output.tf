output "blob_storage_dns_zone_id" {
  value = azurerm_private_dns_zone.blob_privatelink.id
}

output "vault_core_dns_zone_id" {
  value = azurerm_private_dns_zone.vault_core_private_link.id
}

output "adf_dns_zone_id" {
  value = azurerm_private_dns_zone.vault_core_private_link.id
}

output "batch_dns_zone_id" {
  value = azurerm_private_dns_zone.batch_private_link.id
}

output "mongo_cosmos_dns_zone_id" {
  value = azurerm_private_dns_zone.mongo_cosmos_private_link.id
}