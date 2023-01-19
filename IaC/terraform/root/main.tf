# ------------------------------------------------------------------------------------------------------
# Generate a random suffix
# ------------------------------------------------------------------------------------------------------

resource "random_string" "common_suffix" {
  keepers = {
    "resource_group_name" = var.resource_group_name
  }
  length  = 8
  numeric = false
  upper   = false
  special = false
}

# ------------------------------------------------------------------------------------------------------
# Deploy Virtual Network
# ------------------------------------------------------------------------------------------------------

module "virtual_network" {
  source              = "../modules/virtualNetwork"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  vnet_name           = var.vnet_name
  address_space       = var.vnet_address_space
}

# ------------------------------------------------------------------------------------------------------
# Deploy Subnets
# ------------------------------------------------------------------------------------------------------

module "privatelink_subnet" {
  source               = "../modules/subnet"
  resource_group_name  = var.resource_group_name
  location             = var.location
  virtual_network_name = module.virtual_network.virtual_network_name
  subnet_name          = var.privatelink_subnet_name
  address_prefix       = var.privatelink_subnet_address_prefix
  service_endpoints    = var.privatelink_subnet_service_endpoints
}

module "appservice_subnet" {
  source               = "../modules/subnet"
  resource_group_name  = var.resource_group_name
  location             = var.location
  virtual_network_name = module.virtual_network.virtual_network_name
  subnet_name          = var.appservice_subnet_name
  address_prefix       = var.appservice_subnet_address_prefix
  service_endpoints    = var.appservice_subnet_service_endpoints
}

# ------------------------------------------------------------------------------------------------------
# Deploy Private DNS Zones
# ------------------------------------------------------------------------------------------------------

module "dns_zones" {
  source               = "../modules/dnsZones"
  resource_group_name  = var.resource_group_name
}

# ------------------------------------------------------------------------------------------------------
# Deploy CosmosDB
# ------------------------------------------------------------------------------------------------------

module "cosmosdb" {
  source                   = "../modules/cosmosdb"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  tags                     = var.tags
  cosmosdb_name            = var.cosmosdb_name
  cosmosdb_suffix          = random_string.common_suffix.id
  offer_type               = var.cosmosdb_offer_type
  kind                     = var.cosmosdb_kind
  consistency_level        = var.cosmosdb_consistency_level
  replication_location     = var.cosmosdb_replication_location
  capabilities             = var.cosmosdb_capabilities
  backup                   = var.cosmosdb_backup
  total_throughput_limit   = var.cosmosdb_total_throughput_limit
  subnet_id                = module.privatelink_subnet.subnet_id
  mongo_cosmos_dns_zone_id = module.dns_zones.mongo_cosmos_dns_zone_id
}

# ------------------------------------------------------------------------------------------------------
# Deploy key vault
# ------------------------------------------------------------------------------------------------------

module "key_vault" {
  source                 = "../modules/keyVault"
  resource_group_name    = var.resource_group_name
  location               = var.location
  tags                   = var.tags
  key_vault_name         = var.kv_name
  kv_suffix              = random_string.common_suffix.id
  kv_sku_name            = var.kv_sku_name
  subnet_id              = module.privatelink_subnet.subnet_id
  vault_core_dns_zone_id = module.dns_zones.vault_core_dns_zone_id
}

# ------------------------------------------------------------------------------------------------------
# Deploy Data Lake Storage
# ------------------------------------------------------------------------------------------------------

module "adls" {
  source                           = "../modules/dataLakeStorage"
  resource_group_name              = var.resource_group_name
  tags                             = var.tags
  location                         = var.location
  adls_suffix                      = random_string.common_suffix.id
  storage_account_container_config = var.adls_storage_account_container_config
  account_kind                     = var.adls_account_kind
  account_tier                     = var.adls_account_tier
  is_hns_enabled                   = var.adls_is_hns_enabled
  nfsv3_enabled                    = var.adls_nfsv3_enabled
  bypass                           = var.adls_bypass
  default_action                   = var.adls_default_action
  is_manual_connection             = var.adls_is_manual_connection
  last_access_time_enabled         = var.adls_last_access_time_enabled
  blob_storage_cors_origins        = var.adls_blob_storage_cors_origins
  network_rules_subnet_ids         = [module.privatelink_subnet.subnet_id]
  private_link_subnet_id           = module.privatelink_subnet.subnet_id
  blob_storage_dns_zone_id         = module.dns_zones.blob_storage_dns_zone_id
}

# ------------------------------------------------------------------------------------------------------
# Deploy storage account for Batch
# ------------------------------------------------------------------------------------------------------

module "batch_storage_account" {
  source                    = "../modules/storage"
  resource_group_name       = var.resource_group_name
  tags                      = var.tags
  location                  = var.location
  storage_account_name      = var.batch_storage_account_name
  storage_suffix            = random_string.common_suffix.id
  account_replication_type  = var.batch_storage_account_replication_type
  account_kind              = var.batch_storage_account_kind
  account_tier              = var.batch_storage_account_tier
  default_action            = var.batch_storage_default_action  
  subnet_id                 = module.privatelink_subnet.subnet_id
}

# ------------------------------------------------------------------------------------------------------
# Deploy Managed Identity for Batch
# ------------------------------------------------------------------------------------------------------

module "batch_managed_identity" {
  source                  = "../modules/managedIdentity"
  resource_group_name     = var.resource_group_name
  location                = var.location
  managed_identity_name   = var.batch_managed_identity_name
  managed_identity_suffix = random_string.common_suffix.id
  tags                    = var.tags
}

# ------------------------------------------------------------------------------------------------------
# Deploy container registry
# ------------------------------------------------------------------------------------------------------

module "container_registry" {
  source              = "../modules/containerRegistry"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
  acr_name            = var.acr_name
  acr_suffix          = random_string.common_suffix.id
  acr_sku             = var.acr_sku
  batch_uami_id       = module.batch_managed_identity.managed_identity_id
}

# ------------------------------------------------------------------------------------------------------
# Deploy Batch
# ------------------------------------------------------------------------------------------------------

module "batch" {
  source                              = "../modules/batch"
  resource_group_name                 = var.resource_group_name
  location                            = var.location
  tags                                = var.tags
  batch_account_name                  = var.batch_account_name
  batch_account_suffix                = random_string.common_suffix.id
  account_tier                        = var.batch_account_tier
  account_replication_type            = var.batch_account_replication_type
  storage_account_container_map       = var.batch_storage_account_container_map
  pool_allocation_mode                = var.batch_pool_allocation_mode
  storage_account_authentication_mode = var.batch_storage_account_authentication_mode
  identity_type                       = var.batch_identity_type
  orch_pool_name                      = var.batch_orch_pool_name
  vm_size_orch_pool                   = var.batch_vm_size_orch_pool
  node_agent_sku_id_orch_pool         = var.batch_node_agent_sku_id_orch_pool
  storage_image_reference_orch_pool   = var.batch_storage_image_reference_orch_pool
  exec_pool_name                      = var.batch_exec_pool_name
  vm_size_exec_pool                   = var.batch_vm_size_exec_pool
  node_agent_sku_id_exec_pool         = var.batch_node_agent_sku_id_exec_pool
  storage_image_reference_exec_pool   = var.batch_storage_image_reference_exec_pool
  endpoint_configuration              = var.batch_endpoint_configuration
  container_configuration_exec_pool   = var.batch_container_configuration_exec_pool
  node_placement_exec_pool            = var.batch_node_placement_exec_pool
  batch_subnet_id                     = module.privatelink_subnet.subnet_id
  storage_account_id                  = module.batch_storage_account.storage_account_id
  batch_uami_id                       = module.batch_managed_identity.managed_identity_id
  batch_uami_principal_id             = module.batch_managed_identity.managed_identity_principal_id
  registry_server                     = module.container_registry.login_server
  batch_dns_zone_id                   = module.dns_zones.batch_dns_zone_id
}

# ------------------------------------------------------------------------------------------------------
# Deploy Data Factory
# ------------------------------------------------------------------------------------------------------

module "data_factory" {
  source                           = "../modules/adf"
  resource_group_name              = var.resource_group_name
  location                         = var.location
  tags                             = var.tags
  adf_name                         = var.adf_name
  adf_suffix                       = random_string.common_suffix.id
  managed_virtual_network_enabled  = var.adf_managed_virtual_network_enabled
  node_size                        = var.adf_node_size
  virtual_network_id               = module.virtual_network.virtual_network_id
  subnet_id                        = module.privatelink_subnet.subnet_id
  adls_storage_accounts            = module.adls.storage_accounts
  key_vault_id                     = module.key_vault.key_vault_id
  key_vault_name                   = module.key_vault.key_vault_name
  adf_dns_zone_id                  = module.dns_zones.adf_dns_zone_id
}

# ------------------------------------------------------------------------------------------------------
# Deploy Role assignments
# ------------------------------------------------------------------------------------------------------

module "role_assignments" {
  depends_on = [
    module.batch,
    module.data_factory
  ]
  source                   = "../modules/role_assignments"
  adls_storage_accounts    = module.adls.storage_accounts
  batch_storage_account_id = module.batch_storage_account.storage_account_id
  adf_sami_principal_id    = module.data_factory.adf_principal_id
  batch_sami_principal_id  = module.batch.batch_sami_principal_id
  batch_uami_principal_id  = module.batch_managed_identity.managed_identity_principal_id
  batch_account_id         = module.batch.batch_account_id
  key_vault_id             = module.key_vault.key_vault_id
  acr_id                   = module.container_registry.acr_id
  tenant_id                = module.key_vault.tenant_id
  object_id                = module.key_vault.object_id
}

module "kv_secrets" {
  depends_on = [
    module.role_assignments
  ]
  source                   = "../modules/kvSecrets"
  key_vault_id             = module.key_vault.key_vault_id
  batch_key_secret         = module.batch.batch_account_primary_access_key
  batch_storage_key_secret = module.batch_storage_account.storage_account_primary_access_key
}
