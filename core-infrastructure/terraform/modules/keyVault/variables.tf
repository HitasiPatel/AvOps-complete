variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Location where the resources are to be deployed"
  type        = string
}

variable "kv_sku_name" {
  description = "keyvault sku - potential values Standard and Premium"
  type        = string
}

variable "key_vault_name" {
  description = "Key vault name"
  type        = string
}

variable "kv_suffix" {
  description = "Suffix for key vault name"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
}

variable "tags" {
  description = "Tags to associate with the key vault resource"
  type        = map(string)
}

variable "vault_core_dns_zone_id" {
  description = "vault core dns zone id"
  type = string
}
