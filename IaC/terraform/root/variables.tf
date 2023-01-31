# ------------------------------------------------------------------------------------------------------
# Common variables
# ------------------------------------------------------------------------------------------------------

variable "resource_group_name" {
  description = "Resource Group name to host keyvault"
  type        = string
}

variable "location" {
  description = "key vault location"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}

# ------------------------------------------------------------------------------------------------------
# Virtual Network variables
# ------------------------------------------------------------------------------------------------------

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "av-dataops"
}

variable "vnet_address_space" {
  description = "Address Space for the VNET"
  type        = string
  default     = "10.0.0.0/16"
}

# ------------------------------------------------------------------------------------------------------
# Subnets' variables
# ------------------------------------------------------------------------------------------------------

variable "privatelink_subnet_name" {
  description = "Subnet used for private link"
  type        = string
  default     = "privatelink"
}

variable "privatelink_subnet_address_prefix" {
  description = "Address Prefix for the private link subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "privatelink_subnet_service_endpoints" {
  description = "Service Endpoints for the private link subnet"
  type        = list(string)
  default     = ["Microsoft.KeyVault", "Microsoft.Storage"]
}

variable "appservice_subnet_name" {
  description = "Subnet used for app service"
  type        = string
  default     = "appservice"
}

variable "appservice_subnet_address_prefix" {
  description = "Address Prefix for the app service subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "appservice_subnet_service_endpoints" {
  description = "Service Endpoints for the app service subnet"
  type        = list(string)
  default     = ["Microsoft.Web"]
}

# ------------------------------------------------------------------------------------------------------
# Cosmos DB variables
# ------------------------------------------------------------------------------------------------------

variable "cosmosdb_name" {
  description = "Name of the CosmosDB account"
  type        = string
  default     = "av-dataops"
}

variable "cosmosdb_offer_type" {
  description = "Specifies the Offer Type to use for this CosmosDB"
  type        = string
  default     = "Standard"
}

variable "cosmosdb_kind" {
  description = "Specifies the Kind of CosmosDB to create"
  type        = string
  default     = "MongoDB"
}

variable "cosmosdb_consistency_level" {
  description = "The Consistency Level to use for this CosmosDB Account"
  type        = string
  default     = "BoundedStaleness"
}

variable "cosmosdb_replication_location" {
  description = "The name of the Azure region to host replicated data."
  type        = string
  default     = "northeurope"
}

variable "cosmosdb_capabilities" {
  type        = string
  description = "Configures the capabilities to enable for this Cosmos DB account"
  default     = "EnableServerless"
}

variable "cosmosdb_backup" {
  type        = string
  description = "The type of the backup"
  default     = "Continuous"
}

variable "cosmosdb_total_throughput_limit" {
  type        = number
  description = "The total throughput limit imposed on this Cosmos DB account (RU/s)"
  default     = 1000
}


# ------------------------------------------------------------------------------------------------------
# Key Vault Variables
# ------------------------------------------------------------------------------------------------------

variable "kv_sku_name" {
  description = "keyvault sku - potential values standard and premium"
  type        = string
  default     = "standard"
}

variable "kv_name" {
  description = "Key vault name"
  type        = string
  default     = "avdops"
}

# ------------------------------------------------------------------------------------------------------
# Data Lake Storage Variables
# ------------------------------------------------------------------------------------------------------

variable "adls_storage_account_container_config" {
  description = "A nested map of storage accounts to containers to lifecycle policies"
  type        = map(map(map(string)))
  default = {
    "avlanding:LRS" = {
      "landing"       = {}
      "archive"       = { "archive" : "1" }
      "error-landing" = { "delete" : "7" }
    }
    "avraw:ZRS" = {
      "raw"       = { "cool" : "7" }
      "error-raw" = { "delete" : "7" }
    }
    "avderived:ZRS" = {
      "extracted"    = { "cool" : "30" }
      "synchronized" = { "cool" : "30" }
      "derived"      = { "cool" : "30" }
      "curated"      = { "cool" : "90" }
      "annotated"    = {}
    }
  }
}

variable "adls_account_kind" {
  description = "Defines the Kind of account. "
  type        = string
  default     = "StorageV2"
}

variable "adls_account_tier" {
  description = "Defines the Tier to use for this storage account."
  type        = string
  default     = "Standard"
}

variable "adls_is_hns_enabled" {
  description = "Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2"
  type        = bool
  default     = true
}

variable "adls_nfsv3_enabled" {
  description = "Is NFSv3 protocol enabled?"
  type        = bool
  default     = true
}

variable "adls_bypass" {
  description = "Specifies whether traffic is bypassed for Logging/Metrics/AzureServices."
  type        = set(string)
  default     = ["AzureServices"]
}

variable "adls_default_action" {
  description = "Specifies the default action of allow or deny when no other rules match."
  type        = string
  default     = "Deny"
}

variable "adls_is_manual_connection" {
  description = "Does the Private Endpoint require Manual Approval from the remote resource owner?"
  type        = bool
  default     = false
}
variable "adls_last_access_time_enabled" {
  description = "Does last access time enabled?"
  type        = bool
  default     = true
}

variable "adls_blob_storage_cors_origins" {
  description = "Blob storage CORS origins"
  type        = list(any)
  default     = ["https://*.av.com", "http://*.av.corp.com"]
}

# ------------------------------------------------------------------------------------------------------
# Batch Storage Variables
# ------------------------------------------------------------------------------------------------------

variable "batch_storage_account_name" {
  description = "Storage account names and containers"
  type        = string
  default     = "avdops"
}

variable "batch_storage_account_replication_type" {
  description = "Defines the type of replication to use for this storage account. "
  type        = string
  default     = "LRS"
}

variable "batch_storage_account_kind" {
  description = "Defines the Kind of account. "
  type        = string
  default     = "StorageV2"
}

variable "batch_storage_account_tier" {
  description = "Defines the Tier to use for this storage account."
  type        = string
  default     = "Standard"
}

variable "batch_storage_default_action" {
  description = "Specifies the default action of allow or deny when no other rules match."
  type        = string
  default     = "Allow"
}

# ------------------------------------------------------------------------------------------------------
# Batch Managed Identity Variables
# ------------------------------------------------------------------------------------------------------

variable "batch_managed_identity_name" {
  description = "Name of the Managed Identity for Batch"
  type        = string
  default     = "av-dataops-batch"
}

# ------------------------------------------------------------------------------------------------------
# Container Registry Variables
# ------------------------------------------------------------------------------------------------------

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  default     = "avdataops"
}

variable "acr_sku" {
  description = "value"
  type        = string
  default     = "Premium"
}

# ------------------------------------------------------------------------------------------------------
# Batch Variables
# ------------------------------------------------------------------------------------------------------

variable "batch_account_name" {
  description = "Name of the Azure Batch Account"
  type        = string
  default     = "avdataops"
}

variable "batch_account_tier" {
  description = "Defines the Tier to use for this storage account."
  type        = string
  default     = "Standard"
}

variable "batch_account_replication_type" {
  description = "Defines the type of replication to use for this storage account. "
  type        = string
  default     = "LRS"
}

variable "batch_pool_allocation_mode" {
  description = "Specifies the mode to use for pool allocation."
  type        = string
  default     = "BatchService"
}

variable "batch_public_network_access_enabled" {
  description = "Specifies whether public network access is allowed"
  type        = bool
  default     = true
}

variable "batch_storage_account_authentication_mode" {
  description = "Specifies the storage account authentication mode."
  type        = string
  default     = "BatchAccountManagedIdentity"
}

variable "batch_identity_type" {
  description = "Specifies the type of Managed Service Identity that should be configured on this Batch Account."
  type        = string
  default     = "SystemAssigned"
}

variable "batch_orch_pool_name" {
  description = "Specifies the name of the Batch pool."
  type        = string
  default     = "orchestratorpool"
}

variable "batch_vm_size_orch_pool" {
  description = "Specifies the size of the VM created in the Batch pool."
  type        = string
  default     = "standard_a4_v2"
}

variable "batch_node_agent_sku_id_orch_pool" {
  description = "Specifies the SKU of the node agents that will be created in the Batch pool."
  type        = string
  default     = "batch.node.ubuntu 20.04"
}

variable "batch_storage_image_reference_orch_pool" {
  description = "A storage_image_reference for the virtual machines that will compose the Batch pool."
  type        = map(string)
  default = {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}

variable "batch_exec_pool_name" {
  description = "Specifies the name of the Batch pool."
  type        = string
  default     = "executionpool"
}

variable "batch_vm_size_exec_pool" {
  description = "Specifies the size of the VM created in the Batch pool."
  type        = string
  default     = "standard_d8_v3"
}

variable "batch_node_agent_sku_id_exec_pool" {
  description = "Specifies the SKU of the node agents that will be created in the Batch pool."
  type        = string
  default     = "batch.node.ubuntu 20.04"
}

variable "batch_storage_image_reference_exec_pool" {
  description = "A storage_image_reference for the virtual machines that will compose the Batch pool."
  type        = map(string)
  default = {
    publisher = "microsoft-azure-batch"
    offer     = "ubuntu-server-container"
    sku       = "20-04-lts"
    version   = "latest"
  }
}

variable "batch_storage_account_container_map" {
  description = "Storage account names and containers"
  type        = map(list(string))
  default = {
    "avlanding" = ["landing", "archive", "error-landing"],
    "avraw"     = ["raw", "error-raw"],
    "avderived" = ["extracted", "derived", "synchronized", "curated", "annotated"]
  }
}

variable "batch_endpoint_configuration" {
  description = "Endpoint configuration for batch"
  type        = map(string)
  default = {
    backend_port          = 22
    frontend_port_range   = "1-49999"
    protocol              = "TCP"
    access                = "Deny"
    priority              = "150"
    source_address_prefix = "*"
  }
}

variable "batch_container_configuration_exec_pool" {
  description = "The type of container configuration."
  type        = string
  default     = "DockerCompatible"
}

variable "batch_node_placement_exec_pool" {
  description = "The placement policy for allocating nodes in the pool."
  type        = string
  default     = "Regional"
}

# ------------------------------------------------------------------------------------------------------
# Data Factory Variables
# ------------------------------------------------------------------------------------------------------

variable "adf_name" {
  description = "Name of the Azure Data Factory"
  type        = string
  default     = "av-dataops"
}

variable "adf_managed_virtual_network_enabled" {
  description = "Is Managed Virtual Network enabled?"
  type        = bool
  default     = true
}

variable "adf_node_size" {
  description = "The size of the nodes on which the Managed Integration Runtime runs."
  type        = string
  default     = "Standard_D8_v3"
}
