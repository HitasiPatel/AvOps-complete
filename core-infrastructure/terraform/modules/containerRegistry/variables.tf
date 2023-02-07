variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Location where the resources are to be deployed"
  type        = string
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
}

variable "acr_suffix" {
  description = "Suffix for the ACR Name"
  type        = string
}

variable "batch_uami_id" {
  type        = string
  description = "Managed identity ID"
}

variable "acr_sku" {
  description = "value"
  type        = string
}

# variable "private_link_subnet_id" {
#   description = "Subnet for private links"
#   type        = string
# }

# variable "app_service_subnet_id" {
#   description = "Subnet for App service"
#   type        = string
# }

# variable "acr_dns_zone_id" {
#   description = "ACR DNS zone id"
#   type        = string
# }

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}
