variable "resource_group_name" {
  description = "Resource Group name to host storage account"
  type        = string
}

variable "location" {
  description = "Location where the resources are to be deployed"
  type        = string
}

variable "storage_account_name" {
  description = "Storage account names and containers"
  type        = string
}

variable "storage_suffix" {
  description = "Suffix for batch storage account name"
  type        = string
}

variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account. "
  type        = string
}

variable "account_kind" {
  description = "Defines the Kind of account. "
  type        = string
}

variable "account_tier" {
  description = "Defines the Tier to use for this storage account."
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}

variable "subnet_id" {
  description = "Subnet ID"
}

variable "default_action" {
  description = "Specifies the default action of allow or deny when no other rules match."
  type        = string
}
