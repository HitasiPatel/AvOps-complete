output "cosmosdb_account_id" {
  value = azurerm_cosmosdb_account.cosmosdb.id
}

output "cosmosdb_primary_connection_string" {
  value = azurerm_cosmosdb_account.cosmosdb.connection_strings[0]
}
