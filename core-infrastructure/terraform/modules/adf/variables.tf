variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Location where the resources are to be deployed"
  type        = string
}

variable "adf_name" {
  description = "Name of the Azure Data Factory"
  type        = string
}

variable "adf_suffix" {
  description = "Suffix for the Azure Data Factory Name"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}

variable "managed_virtual_network_enabled" {
  description = "Is Managed Virtual Network enabled?"
  type        = bool
}

variable "subnet_id" {
  description = "Virtual network subnet ID"
  type        = string
}

variable "adf_dns_zone_id" {
  description = "Data Factory DNS zone ID"
  type        = string
}

variable "virtual_network_id" {
  description = "Virtual network ID"
  type        = string
}

variable "key_vault_name" {
  description = "Key Vault resource name"
  type        = string
}

variable "adls_storage_accounts" {
  description = "Storage account primary dfs urls"
}

variable "key_vault_id" {
  description = "Key Vault Linked Service ID"
  type        = string
}

variable "batch_storage_account_connection_string" {
  description = "Batch Storage Account connection string"
  type        = string
}

variable "batch_account_endpoint" {
  description = "Batch Account endpoint"
  type        = string
}

variable "batch_account_name" {
  description = "Batch Account Name"
  type        = string
}

variable "batch_account_exec_pool_name" {
  description = "Batch Account exection pool name"
  type        = string
}

variable "node_size" {
  description = "The size of the nodes on which the Managed Integration Runtime runs."
  type        = string
}

variable "app_service_id" {
  description = "App Service Linked Service ID"
  type        = string
}

variable "app_service_name" {
  description = "App Service Linked Service Name"
  type        = string
}
