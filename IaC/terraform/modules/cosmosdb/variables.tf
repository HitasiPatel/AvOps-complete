variable "resource_group_name" {
  description = "Resource Group name to host cosmosDB"
  type        = string
}

variable "cosmosdb_name" {
  description = "Name of the CosmosDB account"
  type        = string
  default     = "cosmosdb"
}

variable "cosmosdb_suffix" {
  description = "Name of the CosmosDB account"
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
  description = "Specifies the Offer Type to use for this CosmosDB"
  type        = string
  default     = "Standard"
}

variable "kind" {
  description = "Specifies the Kind of CosmosDB to create"
  type        = string
  default     = "MongoDB"
}

variable "consistency_level" {
  description = "The Consistency Level to use for this CosmosDB Account"
  type        = string
}

variable "replication_location" {
  description = "The name of the Azure region to host replicated data."
  type        = string
}
