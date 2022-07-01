#######################################################################
## Outputs
#######################################################################
output "vm_data_collection_public_ip_address" {
  value       = azurerm_public_ip.pip_orbital_data_collection.ip_address
  description = "The public IP address of the orbital data collection virtual machine"
}

output "vm_rtstps_public_ip_address" {
  value       = azurerm_public_ip.pip_orbital_rtstps.ip_address
  description = "The public IP address of the orbital rt-stps virtual machine"
}

#output "vm_ipopp_public_ip_address" {
#  value       = azurerm_public_ip.pip_orbital_ipopp.ip_address
#  description = "The public IP address of the orbital ipopp virtual machine"
#}
#output "sa_uri" {
#  value       = azurerm_storage_account.sa_orbital.primary_blob_endpoint
#  description = "The URI of the Storage Account"
#}