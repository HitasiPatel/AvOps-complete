variable "resource_group_name" {
  description = "Resource Group name to host Azure Batch"
  type        = string
}

variable "location" {
  description = "Location where the resources are to be deployed"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}

variable "batch_account_name" {
  description = "Name of the Azure Batch Account"
  type        = string
}

variable "batch_account_suffix" {
  description = "Suffix for batch account name"
  type        = string
}

variable "account_tier" {
  description = "Defines the Tier to use for this storage account."
  type        = string
}

variable "account_replication_type" {
  description = "Defines the type of replication to use for this storage account. "
  type        = string
}

variable "batch_subnet_id" {
  description = "Virtual Network Subnet ID"
}

variable "batch_dns_zone_id" {
  description = "Batch DNS zone ID"
  type        = string
}

variable "storage_account_id" {
  description = "Specifies the storage account to use for the Batch account."
  type        = string
}

variable "pool_allocation_mode" {
  description = "Specifies the mode to use for pool allocation."
  type        = string
}

variable "public_network_access_enabled" {
  description = "Specifies whether public network access is allowed"
  type        = bool
}

variable "storage_account_authentication_mode" {
  description = "Specifies the storage account authentication mode."
  type        = string
}

variable "identity_type" {
  description = "Specifies the type of Managed Service Identity that should be configured on this Batch Account."
  type        = string
}

variable "orch_pool_name" {
  description = "Specifies the name of the Batch pool."
  type        = string
}

variable "vm_size_orch_pool" {
  description = "Specifies the size of the VM created in the Batch pool."
  type        = string
}

variable "node_agent_sku_id_orch_pool" {
  description = "Specifies the SKU of the node agents that will be created in the Batch pool."
  type        = string
}

variable "storage_image_reference_orch_pool" {
  description = "A storage_image_reference for the virtual machines that will compose the Batch pool."
  type        = map(string)
}

variable "exec_pool_name" {
  description = "Specifies the name of the Batch pool."
  type        = string
}

variable "vm_size_exec_pool" {
  description = "Specifies the size of the VM created in the Batch pool."
  type        = string
}

variable "node_agent_sku_id_exec_pool" {
  description = "Specifies the SKU of the node agents that will be created in the Batch pool."
  type        = string
}

variable "storage_image_reference_exec_pool" {
  description = "A storage_image_reference for the virtual machines that will compose the Batch pool."
  type        = map(string)
}

variable "storage_account_container_map" {
  description = "Storage account names and containers"
  type        = map(list(string))
}

variable "batch_uami_id" {
  description = "Managed identity ID"
  type        = string
}

variable "batch_uami_principal_id" {
  description = "Managed identity prinicipal ID"
  type        = string
}

variable "endpoint_configuration" {
  description = "Endpoint configuration."
  type        = map(string)
}

variable "container_configuration_exec_pool" {
  description = "The type of container configuration."
  type        = string
}

variable "node_placement_exec_pool" {
  description = "The placement policy for allocating nodes in the pool."
  type        = string
}

variable "registry_server" {
  description = "The URL that can be used to log into the container registry."
  type        = string
}
