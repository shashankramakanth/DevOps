terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.38.0"
    }
  }
  backend "azurerm" {
    resource_group_name = "<>" #replace with your resource group name
    storage_account_name = "<>" #replace with your storage account name
    container_name      = "aztfcontainer1" 
    key                 = "dev.terraform.tf" #name of the tfstate file,
  } 
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
  subscription_id = "${var.subscription_id}" 
  resource_provider_registrations = "none" #for sandbox account
}

data "azurerm_resource_group" "az-rg-sandbox-01" {
  name     = "${var.resource_group_name}" 
 # location = "southcentralus"
}

resource "azurerm_storage_account" "az-sa-sandbox-01" {
  name                     = "${var.storage_account_name}" #must be globally unique
  resource_group_name      = data.azurerm_resource_group.az-rg-sandbox-01.name #implicit dependency
  location                 = data.azurerm_resource_group.az-rg-sandbox-01.location #implicit dependency
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "sandbox"
    created_by  = "Terraform"
  }
}