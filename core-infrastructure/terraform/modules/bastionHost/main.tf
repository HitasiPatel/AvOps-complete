locals {
  resource_type       = "bastion"
  ip_resource_type    = "ip"
  nsg_resource_type   = "nsg"
  bastion_ip_config   = "bastion-ip-configuration"
  nic_resource_type   = "nic"
  nic_ip_config       = "internal"
  vm_resource_type    = "vm"
  vm_pass_secret_name = "bastionvmpass"
}

resource "azurerm_public_ip" "bastion_ip" {
  name                = "${local.resource_type}-${var.bastion_host_name}-${var.bastion_host_suffix}-${local.ip_resource_type}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.bastion_ip_allocation
  sku                 = var.bastion_ip_sku
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = [var.bastion_subnet_address_prefix]
}

resource "azurerm_network_security_group" "bastion_nsg" {
  name                = "${local.resource_type}-${var.bastion_host_name}-${var.bastion_host_suffix}-${local.nsg_resource_type}"
  resource_group_name = var.resource_group_name
  location            = var.location
  security_rule {
    name                       = "AllowHttpsInbound"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "Internet"
    destination_port_range     = "443"
    destination_address_prefix = "*"
    access                     = "Allow"
    priority                   = 100
    direction                  = "Inbound"
  }
  security_rule {
    name                       = "AllowGatewayManagerInbound"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "GatewayManager"
    destination_port_range     = "443"
    destination_address_prefix = "*"
    access                     = "Allow"
    priority                   = 110
    direction                  = "Inbound"
  }
  security_rule {
    name                       = "AllowLoadBalancerInbound"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_port_range     = "443"
    destination_address_prefix = "*"
    access                     = "Allow"
    priority                   = 120
    direction                  = "Inbound"
  }
  security_rule {
    name                       = "AllowBastionHostCommunicationInbound"
    protocol                   = "*"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_ranges    = ["8080", "5701"]
    destination_address_prefix = "VirtualNetwork"
    access                     = "Allow"
    priority                   = 130
    direction                  = "Inbound"
  }
  security_rule {
    name                       = "DenyAllInbound"
    protocol                   = "*"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "*"
    destination_address_prefix = "*"
    access                     = "Deny"
    priority                   = 1000
    direction                  = "Inbound"
  }
  security_rule {
    name                       = "AllowSshRdpOutbound"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_ranges    = ["22", "3389"]
    destination_address_prefix = "VirtualNetwork"
    access                     = "Allow"
    priority                   = 100
    direction                  = "Outbound"
  }
  security_rule {
    name                       = "AllowAzureCloudCommunicationOutbound"
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "443"
    destination_address_prefix = "AzureCloud"
    access                     = "Allow"
    priority                   = 110
    direction                  = "Outbound"
  }
  security_rule {
    name                       = "AllowBastionHostCommunicationOutbound"
    protocol                   = "*"
    source_port_range          = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_port_ranges    = ["8080", "5701"]
    destination_address_prefix = "VirtualNetwork"
    access                     = "Allow"
    priority                   = 120
    direction                  = "Outbound"
  }
  security_rule {
    name                       = "AllowGetSessionInformationOutbound"
    protocol                   = "*"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_ranges    = ["80", "443"]
    destination_address_prefix = "Internet"
    access                     = "Allow"
    priority                   = 130
    direction                  = "Outbound"
  }
  security_rule {
    name                       = "DenyAllOutbound"
    protocol                   = "*"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "*"
    destination_address_prefix = "*"
    access                     = "Deny"
    priority                   = 1000
    direction                  = "Outbound"
  }
}

resource "azurerm_subnet_network_security_group_association" "bastion" {
  subnet_id                 = azurerm_subnet.bastion_subnet.id
  network_security_group_id = azurerm_network_security_group.bastion_nsg.id
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = "${local.resource_type}-${var.bastion_host_name}-${var.bastion_host_suffix}"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                 = local.bastion_ip_config
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
  }
}

resource "azurerm_network_interface" "bastion_vm_nic" {
  name                = "${local.resource_type}-${var.bastion_host_name}-${var.bastion_host_suffix}-${local.nic_resource_type}"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = local.nic_ip_config
    subnet_id                     = var.bastion_vm_subnet_id
    private_ip_address_allocation = var.bastion_vm_nic_private_ip_allocation
  }
}

resource "random_password" "bastion_vm_password" {
  length = 16
}

resource "azurerm_windows_virtual_machine" "bastion_vm" {
  name                = "${local.resource_type}-${local.vm_resource_type}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.bastion_vm_size
  admin_username      = var.bastion_vm_username
  admin_password      = random_password.bastion_vm_password.result
  network_interface_ids = [
    azurerm_network_interface.bastion_vm_nic.id,
  ]

  os_disk {
    caching              = var.bastion_vm_caching
    storage_account_type = var.bastion_vm_storage_account_type
  }

  source_image_reference {
    publisher = var.bastion_vm_image_publisher
    offer     = var.bastion_vm_image_offer
    sku       = var.bastion_vm_image_sku
    version   = var.bastion_vm_image_version
  }
}

resource "azurerm_key_vault_secret" "azure_bastion_vm_password" {
  name         = local.vm_pass_secret_name
  value        = random_password.bastion_vm_password.result
  key_vault_id = var.key_vault_id
}
