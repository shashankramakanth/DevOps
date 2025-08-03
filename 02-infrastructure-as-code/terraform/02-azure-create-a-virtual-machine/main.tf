terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.38.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
  subscription_id = "${var.subscription_id}" #replace with your subscription id
  resource_provider_registrations = "none" #for sandbox account
}

data "azurerm_resource_group" "az-rg-sandbox-01" {
  name     = "${var.resource_group_name}" #replace with your resource group name
 # location = "westus"
}

#create a vnet
resource "azurerm_virtual_network" "az-vnet-sandbox-01" {
  name                = "${var.prefix}-vnet-sandbox-01"
  resource_group_name = data.azurerm_resource_group.az-rg-sandbox-01.name
  address_space       = ["10.0.0.0/16"]
  location = data.azurerm_resource_group.az-rg-sandbox-01.location
  tags = {
        environment = "sandbox"
        created_by  = "Terraform"
    }
}

#create a privatesubnet
resource "azurerm_subnet" "az-private-subnet-sandbox-01" {
  name                 = "${var.prefix}-privatesubnet-sandbox-01"
  resource_group_name  = data.azurerm_resource_group.az-rg-sandbox-01.name
  virtual_network_name = azurerm_virtual_network.az-vnet-sandbox-01.name
  address_prefixes     = ["10.0.1.0/24"]
}

#create a public subnet
resource "azurerm_subnet" "az-public-subnet-sandbox-01" {
  name                 = "${var.prefix}-publicsubnet-sandbox-01"
  resource_group_name  = data.azurerm_resource_group.az-rg-sandbox-01.name
  virtual_network_name = azurerm_virtual_network.az-vnet-sandbox-01.name
  address_prefixes     = ["10.0.2.0/24"]
}  

#create a network security group
resource "azurerm_network_security_group" "az-nsg-sandbox-01" {
  name                = "${var.prefix}-nsg-sandbox-01"
  location            = data.azurerm_resource_group.az-rg-sandbox-01.location
  resource_group_name = data.azurerm_resource_group.az-rg-sandbox-01.name
    security_rule {
        name                       = "AllowSSH-http-https"
        priority                   = 1000
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_ranges    = ["22","80", "443"]
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

#create a public ip address
resource "azurerm_public_ip" "az-pip-sandbox-01" {
    name                = "${var.prefix}-pip-sandbox-01"
    location            = data.azurerm_resource_group.az-rg-sandbox-01.location
    resource_group_name = data.azurerm_resource_group.az-rg-sandbox-01.name
    allocation_method   = "Static"
    sku                 = "Standard"
}

#create a network interface
resource "azurerm_network_interface" "az-nic-sandbox-01" {
  name                = "${var.prefix}-nic-sandbox-01"
  location            = data.azurerm_resource_group.az-rg-sandbox-01.location
  resource_group_name = data.azurerm_resource_group.az-rg-sandbox-01.name
    ip_configuration {
        name                          = "${var.prefix}-ipconfig-sandbox-01"
        subnet_id                     = azurerm_subnet.az-public-subnet-sandbox-01.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.az-pip-sandbox-01.id
    }
}

#connect the nsg to the public subnet
resource "azurerm_subnet_network_security_group_association" "az-subnet-nsg-sandbox-01" {
  subnet_id                 = azurerm_subnet.az-public-subnet-sandbox-01.id
  network_security_group_id = azurerm_network_security_group.az-nsg-sandbox-01.id
}

#create a virtual machine
resource "azurerm_linux_virtual_machine" "az-vm-sandbox-01" {
  name                = "${var.prefix}-vm-sandbox-01"
  resource_group_name = data.azurerm_resource_group.az-rg-sandbox-01.name
  location            = data.azurerm_resource_group.az-rg-sandbox-01.location
  size                = "Standard_B1s"
  admin_username      = "${var.admin_username}"
  admin_ssh_key {
    username   = "${var.admin_username}"
    public_key = file("~/.ssh/id_rsa.pub") #replace with your public SSH key path
  }
  network_interface_ids = [azurerm_network_interface.az-nic-sandbox-01.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  tags = {
    environment = "sandbox"
    created_by  = "Terraform"
  }
}   