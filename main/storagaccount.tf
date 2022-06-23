#######################################################################
## Create Storage Account with HNS and NFS Enabled
#######################################################################

resource "azurerm_storage_account" "sa_orbital" {
  name                = "saorbital"
  resource_group_name = azurerm_resource_group.rg.name

  location                 = var.location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"

  is_hns_enabled = true
  nfsv3_enabled  = true

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["82.47.118.118"]
    virtual_network_subnet_ids = [azurerm_subnet.endpoint_subnet.id]
  }

  tags = var.tags
}

resource "azurerm_storage_container" "raw_container" {
  name                 = "raw-data"
  storage_account_name = azurerm_storage_account.sa_orbital.name
}

resource "azurerm_storage_container" "rt-stps_container" {
  name                 = "rt-stps"
  storage_account_name = azurerm_storage_account.sa_orbital.name
}

resource "azurerm_storage_container" "ipopp_container" {
  name                 = "ipopp"
  storage_account_name = azurerm_storage_account.sa_orbital.name
}

resource "azurerm_storage_container" "shared_container" {
  name                 = "shared"
  storage_account_name = azurerm_storage_account.sa_orbital.name
}