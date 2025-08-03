variable "prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "aztf"
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = "<>" # replace with your subscription id
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "<>" # replace with your resource group name
}

variable "admin_username" {
    description = "Admin username for the virtual machine"
    type        = string
    default     = "azureuser"
}