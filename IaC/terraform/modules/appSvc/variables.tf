variable "resource_group_name" {
  description = "Resource Group name to host cosmosDB"
  type        = string
}

variable "location" {
  description = "value"
  type        = string
}

variable "virtual_network_id" {
  description = "virtual network id for the apps slot deploy"
  type        = string
}

variable "virtual_network_name" {
  description = "virtual network name for the apps slot deploy"
  type        = string
}

variable "app_service_subnet_id" {
  description = "Subnet id for the apps service deploy"
  type        = string
}

variable "private_link_subnet_id" {
  description = "Subnet id for private endpoints"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}

variable "app_service_dns_zone_id" {
  type        = string
  description = "DNS Zone for App Service"
}

variable "app_svc_suffix" {
  type        = string
  description = "A random suffix for the app service resource name"
}

variable "acr_login_server" {
  type        = string
  description = "URL for ACR"
}

variable "acr_sami_principal_id" {
  type        = string
  description = "ACR System Assigned Managed identity principal ID"
}

variable "app_service_expose_port" {
  type        = number
  description = "Container port that will be exposed to access the app service"
  default     = 3100
}

variable "app_settings" {
  type = map(string)
  description = "App settings which includes the env variables"
  default = {}
}

variable "azure_cosmos_connection_string" {
  type        = string
  description = "Azure Cosmos Primary connection string"
}

variable "azure_cosmos_database_name" {
  type        = string
  description = "Azure Cosmos Database name for mongo API"
  default     = "avops"
}

variable "adls_storage_accounts" {
  description = "Storage accounts list"
}