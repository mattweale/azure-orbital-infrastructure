#######################################################################
## Create NSG
#######################################################################

resource "azurerm_network_security_group" "nsg_orbital_subnet" {
    name                = "nsg-orbital-processing"
    resource_group_name = azurerm_resource_group.rg.name
    location            = var.location

    security_rule {
    name                       = "Port_22"
    priority                   = 201
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "Port_3389"
    priority                   = 202
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
    security_rule {
    name                       = "Port_50001"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "50001"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

    tags = var.tags 

}

#######################################################################
## Associate NSG with Endpoint Subnet
#######################################################################
resource "azurerm_subnet_network_security_group_association" "nsg_endpoint_assoc" {
  subnet_id                 = azurerm_subnet.endpoint_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_orbital_subnet.id
}