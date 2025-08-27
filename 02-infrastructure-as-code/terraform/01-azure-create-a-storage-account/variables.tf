variable "subscription_id" {
  description = "The ID of the Azure subscription where the storage account will be created."
  type        = string
  default     = "<>" # replace with your subscription id
}

variable "resource_group_name" {
  description = "value of the resource group name where the storage account will be created."
  type        = string
  default     = "<>" # replace with your resource group name
}

variable "storage_account_name" {
    description = "The name of the storage account. Must be globally unique."
    type        = string
    default     = "azsatf4c71411a" # replace with your storage account name
}

variable "location" {
  description = "The Azure region where the storage account will be created."
  type        = list(string)
  default     = ["eastus", "westus", "southcentralus"] # replace with your desired location
  
}