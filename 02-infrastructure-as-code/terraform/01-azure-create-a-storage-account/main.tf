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
  subscription_id = "subscription-id" #replace with your subscription id
  resource_provider_registrations = "none" #for sandbox account
}

data "azurerm_resource_group" "az-rg-sandbox-01" {
  name     = "resource-group-name" #replace with your resource group name
 # location = "southcentralus"
}

resource "azurerm_storage_account" "az-sa-sandbox-01" {
  name                     = "storage-account-name " #must be globally unique
  resource_group_name      = data.azurerm_resource_group.az-rg-sandbox-01.name #implicit dependency
  location                 = data.azurerm_resource_group.az-rg-sandbox-01.location #implicit dependency
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    environment = "sandbox"
    created_by  = "Terraform"
  }
}