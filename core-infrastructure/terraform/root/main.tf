# ------------------------------------------------------------------------------------------------------
# General Variables
# ------------------------------------------------------------------------------------------------------

resource "random_string" "common_suffix" {
  keepers = {
    "resource_group_name" = var.resource_group_name
  }
  length  = 5
  numeric = false
  upper   = false
  special = false
}

# ------------------------------------------------------------------------------------------------------
# Create Deployment Resource Group
# ------------------------------------------------------------------------------------------------------

resource "azurerm_resource_group" "deployment_rg" {
  name     = "rg-${var.resource_group_name}-${var.tags.environment}"
  location = var.location
  tags     = var.tags
}

# ------------------------------------------------------------------------------------------------------
# Deploy Virtual Network
# ------------------------------------------------------------------------------------------------------

module "virtual_network" {
  source              = "../modules/virtualNetwork"
  resource_group_name = azurerm_resource_group.deployment_rg.name
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
  resource_group_name  = azurerm_resource_group.deployment_rg.name
  location             = var.location
  virtual_network_name = module.virtual_network.virtual_network_name
  subnet_name          = var.privatelink_subnet_name
  address_prefix       = var.privatelink_subnet_address_prefix
  service_endpoints    = var.privatelink_subnet_service_endpoints
  subnet_delegation    = {}
}

module "batch_nsg" {
  source              = "../modules/nsg"
  nsg_name            = module.privatelink_subnet.subnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.deployment_rg.name
  subnet_id           = module.privatelink_subnet.subnet_id
  tags                = var.tags
}

module "appservice_subnet" {
  source               = "../modules/subnet"
  resource_group_name  = azurerm_resource_group.deployment_rg.name
  location             = var.location
  virtual_network_name = module.virtual_network.virtual_network_name
  subnet_name          = var.appservice_subnet_name
  address_prefix       = var.appservice_subnet_address_prefix
  service_endpoints    = var.appservice_subnet_service_endpoints
  subnet_delegation = {
    app-service-plan = [
      {
        name    = "Microsoft.Web/serverFarms"
        actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
      }
    ]
  }
}

module "databricks_host_subnet" {
  source               = "../modules/subnet"
  resource_group_name  = azurerm_resource_group.deployment_rg.name
  location             = var.location
  virtual_network_name = module.virtual_network.virtual_network_name
  subnet_name          = var.databricks_host_subnet_name
  address_prefix       = var.databricks_host_subnet_address_prefix
  service_endpoints    = var.databricks_host_subnet_service_endpoints
  subnet_delegation = {
    "${var.databricks_host_subnet_name}" = [
      {
        name    = "Microsoft.Databricks/workspaces"
        actions = []
      }
    ]
  }
}

module "databricks_container_subnet" {
  source               = "../modules/subnet"
  resource_group_name  = azurerm_resource_group.deployment_rg.name
  location             = var.location
  virtual_network_name = module.virtual_network.virtual_network_name
  subnet_name          = var.databricks_container_subnet_name
  address_prefix       = var.databricks_container_subnet_address_prefix
  service_endpoints    = var.databricks_container_subnet_service_endpoints
  subnet_delegation = {
    "${var.databricks_container_subnet_name}" = [
      {
        name    = "Microsoft.Databricks/workspaces"
        actions = []
      }
    ]
  }
}

# ------------------------------------------------------------------------------------------------------
# Deploy Private DNS Zones
# ------------------------------------------------------------------------------------------------------

module "dns_zones" {
  source              = "../modules/dnsZones"
  resource_group_name = azurerm_resource_group.deployment_rg.name
}

# ------------------------------------------------------------------------------------------------------
# Deploy CosmosDB
# ------------------------------------------------------------------------------------------------------

module "cosmosdb" {
  source                   = "../modules/cosmosdb"
  resource_group_name      = azurerm_resource_group.deployment_rg.name
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
  private_link_subnet_id   = module.privatelink_subnet.subnet_id
  app_service_subnet_id    = module.appservice_subnet.subnet_id
  mongo_cosmos_dns_zone_id = module.dns_zones.mongo_cosmos_dns_zone_id
}

# ------------------------------------------------------------------------------------------------------
# Deploy App Service 
# ------------------------------------------------------------------------------------------------------

module "app_service" {
  source                         = "../modules/appSvc"
  resource_group_name            = azurerm_resource_group.deployment_rg.name
  location                       = var.location
  tags                           = var.tags
  app_service_subnet_id          = module.appservice_subnet.subnet_id
  private_link_subnet_id         = module.privatelink_subnet.subnet_id
  virtual_network_name           = module.virtual_network.virtual_network_name
  virtual_network_id             = module.virtual_network.virtual_network_id
  app_service_dns_zone_id        = module.dns_zones.app_service_dns_zone_id
  app_svc_suffix                 = random_string.common_suffix.id
  acr_login_server               = module.container_registry.login_server
  acr_sami_principal_id          = module.container_registry.acr_sami_principal_id
  azure_cosmos_connection_string = module.cosmosdb.cosmosdb_primary_connection_string
  adls_storage_accounts          = module.adls.storage_accounts
}

#------------------------------------------------------------------------------------------------------
# Deploy key vault
#------------------------------------------------------------------------------------------------------

module "key_vault" {
  source                 = "../modules/keyVault"
  resource_group_name    = azurerm_resource_group.deployment_rg.name
  location               = var.location
  tags                   = var.tags
  key_vault_name         = var.kv_name
  kv_suffix              = random_string.common_suffix.id
  kv_sku_name            = var.kv_sku_name
  subnet_id              = module.privatelink_subnet.subnet_id
  vault_core_dns_zone_id = module.dns_zones.vault_core_dns_zone_id
}

# ------------------------------------------------------------------------------------------------------
# Deploy Bastion Host
# ------------------------------------------------------------------------------------------------------

module "bastion_host" {
  source                               = "../modules/bastionHost"
  count                                = var.bastion_host_enabled ? 1 : 0
  resource_group_name                  = azurerm_resource_group.deployment_rg.name
  location                             = var.location
  tags                                 = var.tags
  bastion_host_name                    = var.bastion_host_name
  bastion_host_suffix                  = random_string.common_suffix.id
  bastion_subnet_address_prefix        = var.bastion_subnet_address_prefix
  bastion_ip_allocation                = var.bastion_ip_allocation
  bastion_ip_sku                       = var.bastion_ip_sku
  bastion_vm_nic_private_ip_allocation = var.bastion_vm_nic_private_ip_allocation
  bastion_vm_size                      = var.bastion_vm_size
  bastion_vm_username                  = var.bastion_vm_username
  bastion_vm_caching                   = var.bastion_vm_caching
  bastion_vm_storage_account_type      = var.bastion_vm_storage_account_type
  bastion_vm_image_publisher           = var.bastion_vm_image_publisher
  bastion_vm_image_offer               = var.bastion_vm_image_offer
  bastion_vm_image_sku                 = var.bastion_vm_image_sku
  bastion_vm_image_version             = var.bastion_vm_image_version
  virtual_network_name                 = module.virtual_network.virtual_network_name
  bastion_vm_subnet_id                 = module.privatelink_subnet.subnet_id
  key_vault_id                         = module.key_vault.key_vault_id
}

# ------------------------------------------------------------------------------------------------------
# Deploy Data Lake Storage
# ------------------------------------------------------------------------------------------------------

module "adls" {
  source                           = "../modules/dataLakeStorage"
  resource_group_name              = azurerm_resource_group.deployment_rg.name
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
  network_rules_subnet_ids         = [module.privatelink_subnet.subnet_id, module.appservice_subnet.subnet_id, module.databricks_host_subnet.subnet_id]
  private_link_subnet_id           = module.privatelink_subnet.subnet_id
  blob_storage_dns_zone_id         = module.dns_zones.blob_storage_dns_zone_id
}

# ------------------------------------------------------------------------------------------------------
# Deploy storage account for Batch
# ------------------------------------------------------------------------------------------------------

module "batch_storage_account" {
  source                   = "../modules/storage"
  resource_group_name      = azurerm_resource_group.deployment_rg.name
  tags                     = var.tags
  location                 = var.location
  storage_account_name     = var.batch_storage_account_name
  storage_suffix           = random_string.common_suffix.id
  account_replication_type = var.batch_storage_account_replication_type
  account_kind             = var.batch_storage_account_kind
  account_tier             = var.batch_storage_account_tier
  default_action           = var.batch_storage_default_action
  subnet_id                = module.privatelink_subnet.subnet_id
}

# ------------------------------------------------------------------------------------------------------
# Deploy Managed Identity for Batch
# ------------------------------------------------------------------------------------------------------

module "batch_managed_identity" {
  source                  = "../modules/managedIdentity"
  resource_group_name     = azurerm_resource_group.deployment_rg.name
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
  resource_group_name = azurerm_resource_group.deployment_rg.name
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
  resource_group_name                 = azurerm_resource_group.deployment_rg.name
  location                            = var.location
  tags                                = var.tags
  batch_account_name                  = var.batch_account_name
  batch_account_suffix                = random_string.common_suffix.id
  account_tier                        = var.batch_account_tier
  account_replication_type            = var.batch_account_replication_type
  storage_account_container_map       = var.batch_storage_account_container_map
  public_network_access_enabled       = var.batch_public_network_access_enabled
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
  source                                  = "../modules/adf"
  resource_group_name                     = azurerm_resource_group.deployment_rg.name
  location                                = var.location
  tags                                    = var.tags
  adf_name                                = var.adf_name
  adf_suffix                              = random_string.common_suffix.id
  managed_virtual_network_enabled         = var.adf_managed_virtual_network_enabled
  node_size                               = var.adf_node_size
  virtual_network_id                      = module.virtual_network.virtual_network_id
  subnet_id                               = module.privatelink_subnet.subnet_id
  adls_storage_accounts                   = module.adls.storage_accounts
  key_vault_id                            = module.key_vault.key_vault_id
  key_vault_name                          = module.key_vault.key_vault_name
  batch_storage_account_connection_string = module.batch_storage_account.primary_connection_string
  batch_account_endpoint                  = module.batch.batch_account_endpoint
  batch_account_name                      = module.batch.batch_account_name
  batch_account_exec_pool_name            = module.batch.exec_pool_name
  app_service_id                          = module.app_service.app_service_id
  app_service_name                        = module.app_service.app_service_name
  adf_dns_zone_id                         = module.dns_zones.adf_dns_zone_id
}

# ------------------------------------------------------------------------------------------------------
# Deploy Data Bricks
# ------------------------------------------------------------------------------------------------------

module "databricks" {
  source                = "../modules/dataBricks"
  resource_group_name   = azurerm_resource_group.deployment_rg.name
  location              = var.location
  tags                  = var.tags
  databricks_name       = var.databricks_name
  databricks_suffix     = random_string.common_suffix.id
  sku                   = var.databricks_sku
  virtual_network_id    = module.virtual_network.virtual_network_id
  container_subnet_name = module.databricks_container_subnet.subnet_name
  host_subnet_name      = module.databricks_host_subnet.subnet_name
  container_subnet_id   = module.databricks_container_subnet.subnet_id
  host_subnet_id        = module.databricks_host_subnet.subnet_id
}

# ------------------------------------------------------------------------------------------------------
# Deploy Role assignments
# ------------------------------------------------------------------------------------------------------

module "role_assignments" {
  depends_on = [
    module.batch,
    module.data_factory
  ]
  source                        = "../modules/roleAssignments"
  adls_storage_accounts         = module.adls.storage_accounts
  batch_storage_account_id      = module.batch_storage_account.storage_account_id
  adf_sami_principal_id         = module.data_factory.adf_principal_id
  batch_sami_principal_id       = module.batch.batch_sami_principal_id
  batch_uami_principal_id       = module.batch_managed_identity.managed_identity_principal_id
  app_service_sami_principal_id = module.app_service.app_service_sami_principal_id
  batch_account_id              = module.batch.batch_account_id
  key_vault_id                  = module.key_vault.key_vault_id
  acr_id                        = module.container_registry.acr_id
  tenant_id                     = module.key_vault.tenant_id
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

# ------------------------------------------------------------------------------------------------------
# Deploy log analytics workspace
# ------------------------------------------------------------------------------------------------------

module "log_analytics" {
  source                       = "../modules/logAnalytics"
  log_analytics_name           = var.loganalytics_name
  location                     = var.location
  resource_group_name          = azurerm_resource_group.deployment_rg.name
  log_analytics_retention_days = var.loganalytics_retention_days
  log_analytics_sku            = var.loganalytics_sku
  tags                         = var.tags
}

# ------------------------------------------------------------------------------------------------------
# Deploy application insights instance
# ------------------------------------------------------------------------------------------------------

module "app_insights" {
  source              = "../modules/appInsights"
  app_insights_name   = var.appinsights_name
  location            = var.location
  resource_group_name = azurerm_resource_group.deployment_rg.name
  app_insights_type   = var.appinsights_type
  workspace_id        = module.log_analytics.log_analytics_id
  tags                = var.tags
}

# ------------------------------------------------------------------------------------------------------
# Configure diagnostics settings
# ------------------------------------------------------------------------------------------------------

module "diag_virtual_network" {
  source                     = "../modules/diagnosticSettings"
  diagnostic_settings_name   = "tf_default"
  target_resource_id         = module.virtual_network.virtual_network_id
  log_analytics_workspace_id = module.log_analytics.log_analytics_id
  resource_logs              = [{ category = "", category_group = "allLogs", enabled = true }]
  resource_metrics           = ["AllMetrics"]
}

module "diag_batch" {
  source                     = "../modules/diagnosticSettings"
  diagnostic_settings_name   = "tf_default"
  target_resource_id         = module.batch.batch_account_id
  log_analytics_workspace_id = module.log_analytics.log_analytics_id
  resource_logs              = [{ category = "", category_group = "allLogs", enabled = true }]
  resource_metrics           = ["AllMetrics"]
}

module "diag_batch_storage_account" {
  source                     = "../modules/diagnosticSettings"
  diagnostic_settings_name   = "tf_default"
  target_resource_id         = module.batch_storage_account.storage_account_id
  log_analytics_workspace_id = module.log_analytics.log_analytics_id
  resource_logs              = [{ category = "", category_group = "allLogs", enabled = true }]
  resource_metrics           = ["AllMetrics"]
}

module "diag_cosmosdb" {
  source                     = "../modules/diagnosticSettings"
  diagnostic_settings_name   = "tf_default"
  target_resource_id         = module.cosmosdb.cosmosdb_account_id
  log_analytics_workspace_id = module.log_analytics.log_analytics_id
  resource_logs              = [{ category = "", category_group = "allLogs", enabled = true }]
  resource_metrics           = ["AllMetrics"]
}

module "diag_data_factory" {
  source                     = "../modules/diagnosticSettings"
  diagnostic_settings_name   = "tf_default"
  target_resource_id         = module.data_factory.adf_resource_id
  log_analytics_workspace_id = module.log_analytics.log_analytics_id
  resource_logs              = [{ category = "", category_group = "allLogs", enabled = true }]
  resource_metrics           = ["AllMetrics"]
}

module "diag_key_vault" {
  source                     = "../modules/diagnosticSettings"
  diagnostic_settings_name   = "tf_default"
  target_resource_id         = module.key_vault.key_vault_id
  log_analytics_workspace_id = module.log_analytics.log_analytics_id
  resource_logs              = [{ category = "", category_group = "allLogs", enabled = true }]
  resource_metrics           = ["AllMetrics"]
}