locals {
  resource_group_name = module.resource_group.resource_group_name
  location           = module.resource_group.resource_group_location
}

module "resource_group" {
  source           = "../terraform_modules/Azure/resource_group"
  resource_group_name = var.resource_group_name
}

module "vnet1" {
  source              = "../terraform_modules/Azure/VNet"
  resource_group_name = local.resource_group_name
  location            = local.location
  vnet_name           = "vnet1" 
  address_space       = ["10.0.0.0/16"]
}

module "vnet2" {
  source              = "../terraform_modules/Azure/VNet"
  resource_group_name = local.resource_group_name
  location            = local.location
  vnet_name           = "vnet2"
  address_space       = ["10.1.0.0/16"]
}

#Create VNet Peering between vnet1 and vnet2
resource "azurerm_virtual_network_peering" "vnet1_to_vnet2" {
  name                      = "vnet1-to-vnet2"
  resource_group_name       = local.resource_group_name
  virtual_network_name      = module.vnet1.vnet_name
  remote_virtual_network_id = module.vnet2.vnet_id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false

#Allow traffic from vnet1 to vnet2
  allow_virtual_network_access = true
}

#Create VNet Peering between vnet2 and vnet1
resource "azurerm_virtual_network_peering" "vnet2_to_vnet1" {
  name                      = "vnet2-to-vnet1"
  resource_group_name       = local.resource_group_name
  virtual_network_name      = module.vnet2.vnet_name
  remote_virtual_network_id = module.vnet1.vnet_id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = false
  use_remote_gateways       = false

#Allow traffic from vnet2 to vnet1
  allow_virtual_network_access = true
}

resource "azurerm_public_ip" "pip01"{
   name = var.public_ip01_name
   resource_group_name = local.resource_group_name
   location = local.location
   allocation_method = "Static"
   sku = "Standard"
}

resource "azurerm_public_ip" "pip02"{
   name = var.public_ip02_name
   resource_group_name = local.resource_group_name
   location = local.location
   allocation_method = "Static"
   sku = "Standard"
}

module "subnet1" {
  source              = "../terraform_modules/Azure/Subnet"
  resource_group_name = local.resource_group_name
  virtual_network_name = module.vnet1.vnet_name
  subnet_name         = "subnet1"
  address_prefixes    = ["10.0.0.0/24"]
}

module "subnet2" {
  source              = "../terraform_modules/Azure/Subnet"
  resource_group_name = local.resource_group_name
  virtual_network_name = module.vnet2.vnet_name
  subnet_name         = "subnet2"
  address_prefixes    = ["10.1.0.0/24"]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "example-nsg"
  location            = local.location
  resource_group_name = local.resource_group_name

  security_rule {
    name                       = "AllowVNetInBound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

    security_rule {
    name                       = "AllowSSH"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*" // WARNING: Opens SSH to the entire internet
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Demo"
    created_by  = "Terraform"
  }
}

resource "azurerm_subnet_network_security_group_association" "subnet1_nsg_association" {
  subnet_id                 = module.subnet1.subnet_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
resource "azurerm_subnet_network_security_group_association" "subnet2_nsg_association" {
  subnet_id                 = module.subnet2.subnet_id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_network_interface" "nic1" {
  name                = "nic1"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.subnet1.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip01.id
  }

  tags = {
    environment = "Demo"
    created_by  = "Terraform"
  }
}

resource "azurerm_network_interface" "nic2" {
  name                = "nic2"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = module.subnet2.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip02.id
  }

  tags = {
    environment = "Demo"
    created_by  = "Terraform"
  }
}

resource "azurerm_virtual_machine" "vm1" {
  name                  = "vm1"
  location              = local.location
  resource_group_name   = local.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic1.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "osdisk-vm1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_profile {
    computer_name  = "vm1"
    admin_username = "azureuser"
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "Demo"
    created_by  = "Terraform"
  }
}

resource "azurerm_virtual_machine" "vm2" {
  name                  = "vm2"
  location              = local.location
  resource_group_name   = local.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic2.id]
  vm_size               = "Standard_DS1_v2"

  storage_os_disk {
    name              = "osdisk-vm2"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_profile {
    computer_name  = "vm2"
    admin_username = "azureuser"
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "Demo"
    created_by  = "Terraform"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = azurerm_public_ip.pip02.ip_address
      user        = "azureuser"
      password    = var.admin_password
      timeout     = "2m"
  }
    inline = [
      "sudo apt-get update -y"
    ]
}
}
