variable "key_vault_id" {
  description = "Key vault name"
  type        = string
  default     = "keyvault"
}

variable "azure_batch_storage_conn_string_name" {
  description = "Name of the Batch storage account connection string secret"
  type        = string
  default     = "azurebatchstorageconnstring"
}

variable "batch_storage_conn_string_secret" {
  description = "Batch Storage conn string"
  type        = string
}
