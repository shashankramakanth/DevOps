output "resource_group_name" {
  description = "The name of the resource group."
  value       = data.azurerm_resource_group.module_rg.name
}

output "resource_group_location" {
  description = "The location/region of the resource group."
  value       = data.azurerm_resource_group.module_rg.location
}