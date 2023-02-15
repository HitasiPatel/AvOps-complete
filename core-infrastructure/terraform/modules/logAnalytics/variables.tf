variable "resource_group_name" {
  description = "Resource Group name to host Log Analytics"
  type        = string
}

variable "location" {
  description = "Log Analytics location"
  type        = string
}

variable "log_analytics_name" {
  description = "Log Analytics name"
  type        = string
}

variable "log_analytics_retention_days" {
  description = "Log Analytics workspace retention in days"
  type        = number
}

variable "log_analytics_sku" {
  description = "Log Analytics sku"
  type        = string
}

variable "tags" {
  description = "Tags to associate with the log analytics resource"
  type        = map(string)
}
