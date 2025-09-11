output "vm1_public_ip" {
  description = "The public IP address of VM1."
  value       = azurerm_public_ip.pip01.ip_address
}

output "vm2_public_ip" {
  description = "The public IP address of VM2."
  value       = azurerm_public_ip.pip02.ip_address
  
}