variable "adls_storage_accounts" {
  description = "ADLS storage accounts"
}

variable "batch_storage_account_id" {
  description = "batch storage account resource id"
}

variable "adf_sami_principal_id" {
  description = "ADF self assigned managed identity"
}

variable "batch_sami_principal_id" {
  description = "Batch self assigned managed identity"
}

variable "batch_uami_principal_id" {
  description = "Batch user assigned managed identity"
}

variable "batch_account_id" {
  description = "Batch account id"
}

variable "acr_id" {
  description = "Azure Container Registry ID"
}

variable "key_vault_id" {
  description = "key vault id"
}

variable "tenant_id" {
  description = "tenant id"
}

variable "app_service_sami_principal_id" {
  description = "App service System assigned managed identity"
}
