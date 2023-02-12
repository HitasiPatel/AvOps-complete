variable "resource_group_name" {
  description = "Resource Group name to host the subnet"
  type        = string
}

variable "location" {
  description = "Location where the resources are to be deployed"
  type        = string
}

variable "subnet_name" {
  description = "Name of the subnet"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the virtual network to create subnet in"
  type        = string
}

variable "address_prefix" {
  description = "Address Prefix for the subnet"
  type        = string
}

variable "service_endpoints" {
  description = "Service Endpoints associated with the subnet"
}

variable "subnet_delegation" {
  description = "Delegation used for the subnet"
}