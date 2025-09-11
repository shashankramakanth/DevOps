output "subnet_id" {
  description = "The ID of the subnet."
  value       = azurerm_subnet.module_subnet.id
}

output "subnet_name" {
  description = "The name of the subnet."
  value       = azurerm_subnet.module_subnet.name
}

output "subnet_address_prefixes" {
  description = "The address prefixes of the subnet."
  value       = azurerm_subnet.module_subnet.address_prefixes
}