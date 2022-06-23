#######################################################################
## Create Hub vNET
#######################################################################
resource "azurerm_virtual_network" "hub_vnet" {
  name                = "${var.prefix}-hub-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  address_space       = ["172.16.0.0/16"]
  tags                = var.tags
}

#######################################################################
## Create Subnet for Bastion
#######################################################################
resource "azurerm_subnet" "bastion_hub_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["172.16.1.0/24"]
}

#######################################################################
## Create Subnet in Hub for Services
#######################################################################
resource "azurerm_subnet" "services_subnet" {
  name                 = "services-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["172.16.2.0/24"]
}

#######################################################################
## Create Subnet for VMs - Will move into Spoke after testing
#######################################################################
resource "azurerm_subnet" "endpoint_subnet" {
  name                 = "endpoint-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = ["172.16.3.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

#######################################################################
## Create a VNet Peer between Hub and Spoke
#######################################################################
#resource "azurerm_virtual_network_peering" "hub_to_spoke_peer" {
#  name                         = "${var.prefix}hub-to-spoke-peer"
#  resource_group_name          = azurerm_resource_group.rg.name
#  virtual_network_name         = azurerm_virtual_network.hub_vnet.name
#  remote_virtual_network_id    = azurerm_virtual_network.spoke_vnet.id
#  allow_virtual_network_access = true
#  allow_forwarded_traffic      = true
#}