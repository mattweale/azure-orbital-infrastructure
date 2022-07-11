#######################################################################
## Import Existing MI for later use
#######################################################################
data "azurerm_user_assigned_identity" "uamiorbital" {
  resource_group_name = "rg-permanent"
  name                = "uamiorbital"
}

#######################################################################
## Import Existing Storage Account for assigning MI RBAC Scope
#######################################################################
data "azurerm_storage_account" "sa_mrw" {
  resource_group_name = "rg-permanent"
  name                = var.storageaccount
}

#######################################################################
## Create MI for accessng SA
#######################################################################
#resource "azurerm_user_assigned_identity" "uamiorbital" {
#  resource_group_name = azurerm_resource_group.rg.name
#  location            = var.location
#  name = "uamiorbital"
#}

#######################################################################
## Create MI for accessing SA
#######################################################################
resource "azurerm_role_assignment" "ra_mi_sa" {
  scope                = data.azurerm_storage_account.sa_mrw.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_user_assigned_identity.uamiorbital.client_id
}

#output "user_assigned_identity" {
#  value       = azurerm_user_assigned_identity.uamiorbital.client_id
#  description = "The id of the Managed Identity to access app installs in blob store"
#}