terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.38.0"
    }
  }
  required_version = ">= 1.0.0"

  backend "azurerm" {
    resource_group_name  = "1-d367967a-playground-sandbox"
    storage_account_name = "d367967aplaygrounds"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
    
  }
}

provider "azurerm" {   
    features {}
    subscription_id = var.subscription_id
    resource_provider_registrations = "none" #for sandbox account
}