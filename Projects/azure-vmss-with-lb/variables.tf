variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = "missingsubscriptionid" #replace with your subscription id
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "missingresourcegroupname" #replace with your resource group name
}

variable "resource_prefix" {
    description = "value to prefix the resource names"
    type        = string
    default     = "demo"
}

variable "environment" {
    description = "Environment tag value"
    type        = string
    default     = "Production"
        validation {
        condition     = contains(["Production", "Development", "Testing"], var.environment)
        error_message = "Environment must be one of 'Production', 'Development', or 'Testing'."
    }
    
}