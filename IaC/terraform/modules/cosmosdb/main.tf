locals {
  resource_type = "cosmos"
  subnet_ids    = [var.private_link_subnet_id, var.app_service_subnet_id]
}

resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "${local.resource_type}-${var.cosmosdb_name}-${var.cosmosdb_suffix}-${var.tags.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = var.offer_type
  kind                = var.kind
  tags                = var.tags
  consistency_policy {
    consistency_level = var.consistency_level
  }
  capacity {
    total_throughput_limit = var.total_throughput_limit
  }
  capabilities {
    name = var.capabilities
  }
  capabilities {
    name = "EnableMongo"
  }
  capabilities {
    name = "MongoDBv3.4"
  }
  backup {
    type = var.backup
  }
  geo_location {
    location          = var.replication_location
    failover_priority = 0
  }
  is_virtual_network_filter_enabled = true
  dynamic "virtual_network_rule" {
    for_each = local.subnet_ids
    content {
      id                                   = virtual_network_rule.value
      ignore_missing_vnet_service_endpoint = true
    }
  }
}

resource "azurerm_private_endpoint" "cosmos_db_pvt_endpoint" {
  name                = "${local.resource_type}-${var.cosmosdb_name}-${var.tags.environment}-private-endpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_link_subnet_id

  private_service_connection {
    name                           = "${local.resource_type}-${var.cosmosdb_name}-${var.tags.environment}-private-service-connection"
    private_connection_resource_id = azurerm_cosmosdb_account.cosmosdb.id
    subresource_names              = ["MongoDB"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.mongo_cosmos_dns_zone_id]
  }
}
