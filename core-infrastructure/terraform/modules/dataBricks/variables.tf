variable "resource_group_name" {
  description = "Resource Group name to host Databricks workspace"
  type        = string
}

variable "databricks_name" {
  description = "Name of the Databricks workspace"
  type        = string
}

variable "databricks_suffix" {
  description = "Suffix used for Databricks workspace name"
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

variable "sku" {
  description = "SKU to use for the Databricks workspace"
  type        = string
}

variable "virtual_network_id" {
  description = "Virtual network ID to host Databricks workspace"
}

variable "container_subnet_name" {
  description = "Container (private) subnet name used for Databricks"
}

variable "host_subnet_name" {
  description = "Host (public) Subnet name used for Databricks"
}

variable "container_subnet_id" {
  description = "Container (private) subnet ID used for Databricks"
}

variable "host_subnet_id" {
  description = "Host (public) Subnet ID used for Databricks"
}
