variable "vnet_name" {
  description = "The name of the Virtual Network."
  type        = string
  default     = "defaultvnetname"
}

variable "address_space" {
  description = "The address space that is used by the Virtual Network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "resource_group_name" {
  description = "The name of the resource group where the VNet will be created."
  type        = string
}

variable "location" {
  description = "The Azure region where the VNet will be created."
  type        = string
}