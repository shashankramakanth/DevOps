variable "subscription_id" {
  description = "The ID of the Azure subscription where the storage account will be created."
  type        = string
  default     = "<>" # replace with your subscription id or define in tfvars file
}

variable "resource_group_name" {
  description = "value of the resource group name where the storage account will be created."
  type        = string
  default     = "<>" # replace with your resource group name or define in tfvars file
}

variable "display_name" {
  description = "The display name for the user."
  type        = string
  default     = "<>" # replace with your desired display name or define in tfvars file
  
}

variable "username" {
  description = "The username for the user."
  type        = string
  default     = "<>" # replace with your desired username or define in tfvars file
}

variable "domain" {
  type        = string
  description = "The domain for the user, typically in the format 'example.com."
  default     = "<>" # replace with your desired domain or define in tfvars file
}