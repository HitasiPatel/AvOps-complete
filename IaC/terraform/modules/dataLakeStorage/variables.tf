variable "resource_group_name" {
  description = "Resource Group name to host keyvault"
  type        = string
}

variable "location" {
  description = "Location where the resources are to be deployed"
  type        = string
}

variable "adls_suffix" {
  description = "Suffix for ADLS storage account"
  type        = string
}

variable "storage_account_container_config" {
  description = "A nested map of storage accounts to containers to lifecycle policies"
  type = map(map(map(string)))
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

variable "is_hns_enabled" {
  description = "Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2"
  type        = bool
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}

variable "nfsv3_enabled" {
  description = "Is NFSv3 protocol enabled?"
  type        = bool
}

variable "network_rules_subnet_ids" {
  description = "Subnet IDs for network rules"
}

variable "private_link_subnet_id" {
  description = "Subnet ID for private link"
}

variable "blob_storage_dns_zone_id" {
  description = "DNS Zone for Blob storage"
  type        = string
}

variable "bypass" {
  description = "Specifies whether traffic is bypassed for Logging/Metrics/AzureServices."
  type        = set(string)
}

variable "default_action" {
  description = "Specifies the default action of allow or deny when no other rules match. "
  type        = string
}

variable "is_manual_connection" {
  description = "Does the Private Endpoint require Manual Approval from the remote resource owner?"
  type        = bool
}
variable "last_access_time_enabled" {
  description = "Does last access time enabled?"
  type        = bool
}

variable "blob_storage_cors_origins" {
  description = "Blob storage CORS origins"
  type        = list(any)
}
