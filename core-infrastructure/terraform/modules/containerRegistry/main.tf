locals {
  resource_type = "acr"
}

resource "azurerm_container_registry" "acr" {
  name                          = "${local.resource_type}${var.acr_name}${var.acr_suffix}"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = var.acr_sku
  admin_enabled                 = true
  #public_network_access_enabled = false

  # network_rule_set {
  #   virtual_network = [
  #     {
  #       action    = "Allow"
  #       subnet_id = var.private_link_subnet_id
  #     },
  #     {
  #       action    = "Allow"
  #       subnet_id = var.app_service_subnet_id
  #     }
  #   ]
  # }

  tags = var.tags
  identity {
    type = "SystemAssigned"
  }
}

# resource "azurerm_private_endpoint" "acr_private_endpoint" {
#   name                = "${azurerm_container_registry.acr.name}-private-endpoint"
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   subnet_id           = var.private_link_subnet_id

#   private_dns_zone_group {
#     name                 = "default"
#     private_dns_zone_ids = [var.acr_dns_zone_id]
#   }

#   private_service_connection {
#     name                           = "private_ep_connection"
#     private_connection_resource_id = azurerm_container_registry.acr.id
#     subresource_names              = ["registry"]
#     is_manual_connection           = false
#   }
# }