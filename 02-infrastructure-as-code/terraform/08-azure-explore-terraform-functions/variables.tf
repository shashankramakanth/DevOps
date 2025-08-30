variable "subscription_id" {
  description = "The ID of the Azure subscription where the resources will be created."
  type        = string
  default     = "<>" # replace with your subscription id
}

variable "resource_group_name" {
  description = "value of the resource group name where the resources will be created."
  type        = string
  default     = "Project ALPHA Resource" # replace with your resource group name
}

variable "default_tags" {
    description = "A map of tags to assign to the resources."
    type        = map(string)
    default     = {
        environment = "sandbox"
        created_by  = "Terraform"
    }
}

variable "environment_tags" {
    description = "A map of environment specific tags to assign to the resources."
    type        = map(string)
    default     = {
        project     = "Project ALPHA"
        owner       = "DevOps Team"
    }
  
}

variable "storage_account_name" {
    description = "The name of the storage account. Must be globally unique."
    type        = string
    default     = "azsatf4c1234567890122345667788!!!" # replace with your storage account name
}

variable "port_list" {
  description = "Comma-separated list of ports"
  type        = string
  default     = "80,443,8080,3306"
}

variable "environments" {
    description = "List of environments"
    type       = map(object({
        instance_size = string
        redundancy    = string
    }    ))
    default = {
        dev  = { instance_size = "Standard_B1s", redundancy = "Low" }
        test = { instance_size = "Standard_B2s", redundancy = "Low" }
        prod = { instance_size = "Standard_D2s_v3", redundancy = "High" }
    }

}