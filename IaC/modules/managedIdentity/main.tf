resource "azurerm_user_assigned_identity" "managed_identity" {
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  name = "${var.managed_identity_name}-${var.managed_identity_suffix}-${var.tags.environment}"

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
