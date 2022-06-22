#######################################################################
## Create Event Hub
#######################################################################
resource "azurerm_eventhub_namespace" "eh-orbital-ns" {
  name                = "orbital-eh-namespace"
  location            = var.location 
  resource_group_name = azurerm_resource_group.rg.name 
  sku                 = "Standard"
  capacity            = 1

  tags                = var.tags
}

resource "azurerm_eventhub" "eh-orbital" {
  name                = "orbital-eh"
  namespace_name      = azurerm_eventhub_namespace.eh-orbital-ns.name
  resource_group_name = azurerm_resource_group.rg.name
  partition_count     = 2
  message_retention   = 1
}