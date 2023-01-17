resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                = "${var.cosmosdb_name}-${var.cosmosdb_suffix}-${var.tags.environment}"
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
} 
