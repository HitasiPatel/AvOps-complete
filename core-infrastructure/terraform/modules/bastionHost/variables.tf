variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Location where the resources are to be deployed"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
}

variable "bastion_host_name" {
  description = "Name of the Bastion Host"
  type        = string
}

variable "bastion_host_suffix" {
  description = "Suffix for the Bastion Host Name"
  type        = string
}

variable "bastion_subnet_address_prefix" {
  description = "Address prefix for the bastion subnet"
  type        = string
}

variable "bastion_ip_allocation" {
  description = "Allocation type for the Bastion Host IP"
  type        = string
}

variable "bastion_ip_sku" {
  description = "SKU for the Bastion Host IP"
  type        = string
}

variable "virtual_network_name" {
  description = "VNet to attach the Bastion Host to"
  type        = string
}

variable "bastion_vm_nic_private_ip_allocation" {
  description = "Private IP Allocation type for the Bastion VM Nic"
  type        = string
}

variable "bastion_vm_size" {
  description = "Size to use for the Bastion VM"
  type        = string
}

variable "bastion_vm_username" {
  description = "Username for the Bastion VM"
  type        = string
}

variable "bastion_vm_caching" {
  description = "Caching type for the Bastion VM"
  type        = string
}

variable "bastion_vm_storage_account_type" {
  description = "Storage Account Type for the Bastion VM"
  type        = string
}

variable "bastion_vm_image_publisher" {
  description = "Image publisher for the Bastion VM"
  type        = string
}

variable "bastion_vm_image_offer" {
  description = "Image offer for the Bastion VM"
  type        = string
}

variable "bastion_vm_image_sku" {
  description = "Image SKU for the Bastion VM"
  type        = string
}

variable "bastion_vm_image_version" {
  description = "Image Version for the Bastion VM"
  type        = string
}

variable "bastion_vm_subnet_id" {
  description = "Subnet ID for the Bastion VM"
  type        = string
}

variable "key_vault_id" {
  description = "Key Vault ID to store the bastion VM password"
  type        = string
}