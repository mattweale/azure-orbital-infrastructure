#######################################################################
## Import Existing Storage Account for assigning MI RBAC Scope
#######################################################################
data "azurerm_storage_account" "sa_aqua_tool" {
  resource_group_name = "rg-permanent"
  name                = var.aqua_tools_sa
}

#######################################################################
## Create MI for accessng SA
#######################################################################
resource "azurerm_user_assigned_identity" "uamiorbital" {
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  name                = "uamiorbital"
}

#######################################################################
## Create MI for accessing SA
#######################################################################
resource "azurerm_role_assignment" "ra_mi_sa" {
  scope                = data.azurerm_storage_account.sa_aqua_tool.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.uamiorbital.principal_id
}