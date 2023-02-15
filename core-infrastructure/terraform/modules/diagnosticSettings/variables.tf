variable "diagnostic_settings_name" {
  description = "Name of diagnostic settings"
  type        = string
}

variable "target_resource_id" {
  description = "Target resource ID"
}

variable "log_analytics_workspace_id" {
  description = "ID of Log Analytics workspace"
}

variable "resource_logs" {
  description = "Resource logs"
  type        = list(object({ category=string, category_group=string, enabled=bool }))
}

variable "resource_metrics" {
  description = "Resource metrics"
  type        = list(string)
}
