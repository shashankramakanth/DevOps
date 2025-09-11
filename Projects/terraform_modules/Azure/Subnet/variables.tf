variable "subnet_name" {
  description = "The name of the Subnet."
  type        = string
  default     = "defaultsubnetname"
}

variable "address_prefixes" {
  description = "The address prefixes to use for the subnet."
  type        = list(string)
  default     = ["10.0.0.0/24"]
}

variable "resource_group_name" {
  description = "The name of the resource group where the VNet will be created."
  type        = string
  default = "value"
}

variable "virtual_network_name" {
  description = "The name of the Virtual Network."
  type        = string
  default = "value"
}