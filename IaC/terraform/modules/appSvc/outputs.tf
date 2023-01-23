output "app_service_name" {
  value = azurerm_linux_web_app.linux_web_app.name
}

output "app_service_id" {
  value = azurerm_linux_web_app.linux_web_app.id
}

output "app_service_sami_principal_id" {
  value = azurerm_linux_web_app.linux_web_app.identity[0].principal_id
}

output "app_service_default_host_name" {
  value = azurerm_linux_web_app.linux_web_app.default_hostname
}