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
    validation {
      condition = length(var.storage_account_name) <= 24 && can(regex("^[a-z0-9]+$", var.storage_account_name))
      error_message = "Storage account name must be between 3 and 24 characters in length and can contain only lowercase letters and numbers."
    }
}