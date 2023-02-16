resource "azurerm_service_plan" "app_svc_plan" {
  name                = "${local.resource_type_app_svc_plan}${var.app_svc_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "P1v2"
  tags                = var.tags
}

resource "azurerm_linux_web_app" "linux_web_app" {
  name                      = "${local.resource_type_linux_web_app}${var.app_svc_suffix}"
  resource_group_name       = var.resource_group_name
  location                  = var.location
  service_plan_id           = azurerm_service_plan.app_svc_plan.id
  virtual_network_subnet_id = var.app_service_subnet_id

  identity {
    type = "SystemAssigned"
  }
  app_settings = merge(local.app_settings, var.app_settings)

  site_config {
    container_registry_use_managed_identity       = true
    container_registry_managed_identity_client_id = var.acr_sami_principal_id

    application_stack {
      docker_image     = "${var.acr_login_server}/${local.app_name}"
      docker_image_tag = "latest"
    }
  }

  tags = var.tags
}

resource "azurerm_resource_group_template_deployment" "app_service_deployment_config" {
  name                = "${resource.azurerm_linux_web_app.linux_web_app.name}-deploy"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"
  depends_on = [
    azurerm_linux_web_app.linux_web_app
  ]
  parameters_content = jsonencode({
    "appServiceName" = { value = resource.azurerm_linux_web_app.linux_web_app.name }
    "location"       = { value = var.location }
  })
  template_content = file("${path.module}/app-service-deployment-config.json")
}

resource "null_resource" "enable_app_service_cd" {
  depends_on = [
    azurerm_linux_web_app.linux_web_app
  ]
  provisioner "local-exec" {
    command = "chmod +x ${local.app_service_cd_script_path};  ${local.app_service_cd_script_path} ${var.resource_group_name} ${azurerm_linux_web_app.linux_web_app.name} ${var.acr_name}"
  }
}

resource "azurerm_private_endpoint" "linux_web_app_endpoint" {
  name                = "${azurerm_linux_web_app.linux_web_app.name}-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_link_subnet_id

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.app_service_dns_zone_id]
  }

  private_service_connection {
    name                           = "private_ep_connection"
    private_connection_resource_id = azurerm_linux_web_app.linux_web_app.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}