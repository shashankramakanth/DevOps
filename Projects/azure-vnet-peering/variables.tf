variable "subscription_id" {
  description = "The ID of the Azure subscription in which to create the resources."
  type        = string
  default     = "readfromtfvarsfile"
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string
  default     = "readfromtfvarsfile"
}

variable "public_ip01_name" {
  description = "The name of the Public IP Address."
  type        = string
  default     = "defaultpublicipname"
}

variable "admin_password" {
    description = "The admin password for the VMs."
    type        = string
    sensitive = true
}

variable "public_ip02_name" {
  description = "The name of the Public IP Address."
  type        = string
  default     = "defaultpublicipname"
}