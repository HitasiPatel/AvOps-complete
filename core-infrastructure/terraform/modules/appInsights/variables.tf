variable "resource_group_name" {
  description = "Resource Group name to host Application Insights"
  type        = string
}

variable "location" {
  description = "Application Insights location"
  type        = string
}

variable "app_insights_name" {
  description = "Application Insights name"
  type        = string
}

variable "app_insights_type" {
  description = "Application Insights type"
  type        = string
}

variable "workspace_id" {
  description = "Workspace ID to use with App Insights"
}

variable "tags" {
  description = "Tags to associate with the app insights resource"
  type        = map(string)
}
