#######################################################################
## Create Resource Group
#######################################################################
resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.prefix}"
  location = var.location
  tags     = var.tags
}

#######################################################################
## Import Existing MI for later use
#######################################################################
data "azurerm_user_assigned_identity" "uamiorbital" {
  resource_group_name = "rg-permanent"
  name                = "uamiorbital"
}