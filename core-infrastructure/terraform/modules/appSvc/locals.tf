locals {
  resource_type_app_svc_plan  = "app-svc-plan"
  resource_type_linux_web_app = "web-app-linux"
  app_name                    = "metadata-api"
  app_image_tag               = "latest"
  app_settings = {
    WEBSITES_PORT                          = var.app_service_expose_port
    AZURE_COSMOS_CONNECTION_STRING         = var.azure_cosmos_connection_string
    AZURE_COSMOS_DATABASE_NAME             = var.azure_cosmos_database_name
    ENABLE_LOGS_ON_TRACES                  = false
    AZURE_LOG_LEVEL                        = "INFO"
    AZURE_STORAGE_ACCOUNT_RAW_ZONE_URL     = var.adls_storage_accounts["avraw"].primary_blob_endpoint
    AZURE_STORAGE_ACCOUNT_DERIVED_ZONE_URL = var.adls_storage_accounts["avderived"].primary_blob_endpoint
  }
}
