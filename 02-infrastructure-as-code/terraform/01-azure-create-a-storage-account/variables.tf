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
    default     = "<>" # replace with your storage account name
}