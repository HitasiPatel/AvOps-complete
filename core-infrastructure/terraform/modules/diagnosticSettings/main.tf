resource "azurerm_monitor_diagnostic_setting" "diagnostic_settings" {
  name                       = var.diagnostic_settings_name
  target_resource_id         = var.target_resource_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = {for index, log in var.resource_logs: index => log}

    content {
      category = log.value.category
      category_group = log.value.category_group
      enabled  = log.value.enabled

      # retention_policy unneeded when sending data to Log Analytics
      retention_policy {
        enabled = false
        days    = 0
      }
    }
  }

  dynamic "metric" {
    for_each = var.resource_metrics

    content {
      category = metric.value
      enabled  = true

      # retention_policy unneeded when sending data to Log Analytics
      retention_policy {
        enabled = false
        days    = 0
      }
    }
  }
}
