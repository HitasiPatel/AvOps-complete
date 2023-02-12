variable "resource_group_name" {
  description = "Resource Group name to host the virtual network"
  type        = string
}

variable "location" {
  description = "Location where the resources are to be deployed"
  type        = string
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "Address Space for the VNET"
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}
