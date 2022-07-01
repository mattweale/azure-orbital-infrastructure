#######################################################################
## Create PIP and NIC for RTSTPS VM
#######################################################################
resource "azurerm_public_ip" "pip_orbital_ipopp" {
  name                = "pip-orbital-data-ipopp"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  domain_name_label   = "aqua-ipopp"
  tags                = var.tags
}

resource "azurerm_network_interface" "nic_orbital_data_ipopp" {
  name                = "nic-orbital-data-ipopp"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.endpoint_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_orbital_ipopp.id
  }
}
#######################################################################
## Create Linux VM ffor RTSTPS VM
#######################################################################
resource "azurerm_linux_virtual_machine" "vm_orbital_ipopp" {
  name                            = "vm-orbital-ipopp"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  size                            = var.vmsize
  admin_username                  = "adminuser"
  admin_password                  = "Pa55w0rd123!"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic_orbital_data_ipopp.id,
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = 100
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_9-gen2"
    version   = "latest"
  }
    identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.uamiorbital.id]
  } 
}

#######################################################################
## Create Data Disk and Attach to VM
#######################################################################
resource "azurerm_managed_disk" "data_disk_orbital_ipopp_vm" {
  name                 = "orbital-ipopp-vm-data-disk"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = var.location
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 256
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_orbital_ipopp_attach" {
  managed_disk_id    = azurerm_managed_disk.data_disk_orbital_ipopp_vm.id
  virtual_machine_id = azurerm_linux_virtual_machine.vm_orbital_ipopp.id
  lun                = "10"
  caching            = "ReadWrite"
}

##########################################################
## Custom Script Extension to Configure VM
##########################################################
resource "azurerm_virtual_machine_extension" "cse_vm_orbital_ipopp_config" {
  name                       = "cse_orbital-ipopp-config"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm_orbital_ipopp.id
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "CustomScript"
  type_handler_version       = "2.1"
  auto_upgrade_minor_version = true
  depends_on                 = [azurerm_virtual_machine_data_disk_attachment.data_disk_orbital_ipopp_attach]
  timeouts {
    create = "60m"
  }
  settings = <<SETTINGS
    {
        "commandToExecute":"sudo ./main_ipopp.sh > ./logfile.txt exit 0",
        "fileUris":["https://raw.githubusercontent.com/mattweale/azure-orbital-infrastructure/main/vm_configuration/mount_data_drive.sh",
                    "https://raw.githubusercontent.com/mattweale/azure-orbital-infrastructure/main/vm_configuration/mount_container.sh",
                    "https://raw.githubusercontent.com/mattweale/azure-orbital-infrastructure/main/vm_configuration/main_ipopp.sh",
                    "https://raw.githubusercontent.com/mattweale/azure-orbital-infrastructure/main/vm_configuration/install_ipopp_prepare.sh",
                    "https://raw.githubusercontent.com/mattweale/azure-orbital-infrastructure/main/vm_configuration/install_ipopp_prereqs.sh"]
    }
SETTINGS
  tags     = var.tags
}