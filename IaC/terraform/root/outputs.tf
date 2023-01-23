output "virtual_network_name" {
  value = module.virtual_network.virtual_network_name
}

output "privatelink_subnet_name" {
  value = module.privatelink_subnet.subnet_name
}

output "key_vault_name" {
  value = module.key_vault.key_vault_name
}

output "batch_storage_account_name" {
  value = module.batch_storage_account.storage_account_name
}

output "exec_pool_name" {
  value = module.batch.exec_pool_name
}

output "orch_pool_name" {
  value = module.batch.orch_pool_name
}

output "managed_identity_name" {
  value = module.batch_managed_identity.managed_identity_name
}

output "container_registry_name" {
  value = module.container_registry.acr_name
}

output "batch_account_name" {
  value = module.batch.batch_account_name
}

output "data_factory_name" {
  value = module.data_factory.adf_name
}

output "app_svc_name" {
  value = module.app_service.app_service_name
}

output "metadata_api_url" {
  value = "https://${module.app_service.app_service_default_host_name}"
}
