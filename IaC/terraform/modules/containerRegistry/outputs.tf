output "acr_name" {
  value = azurerm_container_registry.acr.name
}

output "acr_id" {
  value = azurerm_container_registry.acr.id
}

output "login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_sami_principal_id" {
  value = azurerm_container_registry.acr.identity[0].principal_id
}
