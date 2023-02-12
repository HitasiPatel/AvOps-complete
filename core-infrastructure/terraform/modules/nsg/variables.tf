variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Location where the resources are to be deployed"
  type        = string
}

variable "nsg_name" {
  description = "Name of the nsg"
  type        = string
}

variable "subnet_id" {
  description = "ID of the Subnet"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}
