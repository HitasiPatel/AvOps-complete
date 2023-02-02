variable "resource_group_name" {
  description = "Resource Group name to host cosmosDB"
  type        = string
}

variable "cosmosdb_name" {
  description = "Name of the CosmosDB account"
  type        = string
}

variable "cosmosdb_suffix" {
  description = "Suffix used for CosmosDB account name"
  type        = string
}

variable "location" {
  description = "value"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}

variable "offer_type" {
  description = "Specifies the offer type to use for this CosmosDB"
  type        = string
}

variable "kind" {
  description = "Specifies the kind of CosmosDB to create"
  type        = string
}

variable "consistency_level" {
  description = "The Consistency Level to use for this CosmosDB Account"
  type        = string
}

variable "replication_location" {
  description = "The name of the Azure region to host replicated data."
  type        = string
}

variable "private_link_subnet_id" {
  description = "Subnet ID for cosmos DB private endpoint"
}

variable "app_service_subnet_id" {
  description = "Subnet ID for app service instance"
}

variable "capabilities" {
  type        = string
  description = "Configures the capabilities to enable for this Cosmos DB account"
}

variable "backup" {
  type        = string
  description = "The type of the backup"
}

variable "total_throughput_limit" {
  type        = number
  description = "The total throughput limit imposed on this Cosmos DB account (RU/s)"
}

variable "mongo_cosmos_dns_zone_id" {
  type        = string
  description = "DNS Zone for Mongo API for Cosmos DB"
}
