# ------------------------------------------------------------------------------------------------------
# Common values
# ------------------------------------------------------------------------------------------------------

resource_group_name = "rg-avdataops-dev"
location            = "westeurope"
tags = {
  environment = "dev",
}

# ------------------------------------------------------------------------------------------------------
# Virtual Network values
# ------------------------------------------------------------------------------------------------------

vnet_name          = "av-dataops"
vnet_address_space = "10.0.0.0/16"

# ------------------------------------------------------------------------------------------------------
# Subnets' values
# ------------------------------------------------------------------------------------------------------

privatelink_subnet_name              = "privatelink"
privatelink_subnet_address_prefix    = "10.0.1.0/24"
privatelink_subnet_service_endpoints = ["Microsoft.KeyVault", "Microsoft.Storage"]

appservice_subnet_name              = "appservice"
appservice_subnet_address_prefix    = "10.0.2.0/24"
appservice_subnet_service_endpoints = ["Microsoft.Web"]

# ------------------------------------------------------------------------------------------------------
# Cosmos DB values
# ------------------------------------------------------------------------------------------------------

cosmosdb_replication_location   = "northeurope"
cosmosdb_name                   = "av-dataops-cosmosdb"
cosmosdb_offer_type             = "Standard"
cosmosdb_kind                   = "MongoDB"
cosmosdb_consistency_level      = "BoundedStaleness"
cosmosdb_capabilities           = "EnableServerless"
cosmosdb_backup                 = "Continuous"
cosmosdb_total_throughput_limit = 1000

# ------------------------------------------------------------------------------------------------------
# Key Vault values
# ------------------------------------------------------------------------------------------------------

kv_sku_name = "standard"
kv_name     = "avdops"

# ------------------------------------------------------------------------------------------------------
# Data Lake Storage values
# ------------------------------------------------------------------------------------------------------

adls_storage_account_container_config = {
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
adls_account_kind              = "StorageV2"
adls_account_tier              = "Standard"
adls_is_hns_enabled            = true
adls_nfsv3_enabled             = true
adls_bypass                    = ["AzureServices"]
adls_default_action            = "Deny"
adls_is_manual_connection      = false
adls_last_access_time_enabled  = true
adls_blob_storage_cors_origins = ["https://*.av.com", "http://*.av.corp.com"]

# ------------------------------------------------------------------------------------------------------
# Batch Storage values
# ------------------------------------------------------------------------------------------------------

batch_storage_account_name             = "avdopsbatch"
batch_storage_account_replication_type = "LRS"
batch_storage_account_kind             = "StorageV2"
batch_storage_account_tier             = "Standard"
batch_storage_default_action           = "Allow"

# ------------------------------------------------------------------------------------------------------
# Batch Managed Identity values
# ------------------------------------------------------------------------------------------------------

batch_managed_identity_name = "av-dataops-batch-mi"

# ------------------------------------------------------------------------------------------------------
# Container Registry values
# ------------------------------------------------------------------------------------------------------

acr_name = "avdataopsacr"
acr_sku  = "Premium"

# ------------------------------------------------------------------------------------------------------
# Batch values
# ------------------------------------------------------------------------------------------------------

batch_account_name                        = "avdops"
batch_account_tier                        = "Standard"
batch_account_replication_type            = "LRS"
batch_pool_allocation_mode                = "BatchService"
batch_storage_account_authentication_mode = "BatchAccountManagedIdentity"
batch_identity_type                       = "SystemAssigned"
batch_orch_pool_name                      = "orchestratorpool"
batch_vm_size_orch_pool                   = "standard_a4_v2"
batch_node_agent_sku_id_orch_pool         = "batch.node.ubuntu 20.04"
batch_exec_pool_name                      = "executionpool"
batch_vm_size_exec_pool                   = "standard_d8_v3"
batch_node_agent_sku_id_exec_pool         = "batch.node.ubuntu 20.04"
batch_container_configuration_exec_pool   = "DockerCompatible"
batch_node_placement_exec_pool            = "Regional"
batch_storage_image_reference_orch_pool = {
  publisher = "canonical"
  offer     = "0001-com-ubuntu-server-focal"
  sku       = "20_04-lts"
  version   = "latest"
}
batch_storage_image_reference_exec_pool = {
  publisher = "microsoft-azure-batch"
  offer     = "ubuntu-server-container"
  sku       = "20-04-lts"
  version   = "latest"
}
batch_storage_account_container_map = {
  "avlanding" = ["landing", "archive", "error-landing"],
  "avraw"     = ["raw", "error-raw"],
  "avderived" = ["extracted", "derived", "synchronized", "curated", "annotated"]
}
batch_endpoint_configuration = {
  backend_port          = 22
  frontend_port_range   = "1-49999"
  protocol              = "TCP"
  access                = "Deny"
  priority              = "150"
  source_address_prefix = "*"
}

# ------------------------------------------------------------------------------------------------------
# Data Factory values
# ------------------------------------------------------------------------------------------------------

adf_name = "av-dataops-adf"
adf_managed_virtual_network_enabled = true
adf_node_size = "Standard_D8_v3"
