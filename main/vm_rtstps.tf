#######################################################################
## Create PIP and NIC for RTSTPS VM
#######################################################################
resource "azurerm_public_ip" "pip_orbital_rtstps" {
  name                = "pip-orbital-data-rtstps"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  domain_name_label   = "aqua-rtstpt"
  tags                = var.tags
}

resource "azurerm_network_interface" "nic_orbital_data_rtstps" {
  name                = "nic-orbital-data-rtstps"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.endpoint_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip_orbital_rtstps.id
  }
}
#######################################################################
## Create Linux VM for RTSTPS VM
#######################################################################
resource "azurerm_linux_virtual_machine" "vm_orbital_rtstps" {
  name                            = "vm-orbital-rtstps"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = var.location
  size                            = var.vmsize
  admin_username                  = "adminuser"
  admin_password                  = "Pa55w0rd123!"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic_orbital_data_rtstps.id,
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
    #identity_ids = [azurerm_user_assigned_identity.uamiorbital.id]
    identity_ids = [data.azurerm_user_assigned_identity.uamiorbital.id]
  }
}

#######################################################################
## Create Data Disk and Attach to VM
#######################################################################
resource "azurerm_managed_disk" "data_disk_orbital_rtstps_vm" {
  name                 = "orbital-rtstps-vm-data-disk"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = var.location
  storage_account_type = "Premium_LRS"
  create_option        = "Empty"
  disk_size_gb         = 256
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_orbital_rtstps_attach" {
  managed_disk_id    = azurerm_managed_disk.data_disk_orbital_rtstps_vm.id
  virtual_machine_id = azurerm_linux_virtual_machine.vm_orbital_rtstps.id
  lun                = "10"
  caching            = "ReadWrite"
}

#######################################################################
## Custom Script Extension to Configure VM
#######################################################################
resource "azurerm_virtual_machine_extension" "cse_vm_orbital_rtstps_config" {
  name                       = "cse_orbital-rtstps-config"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm_orbital_rtstps.id
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "CustomScript"
  type_handler_version       = "2.1"
  auto_upgrade_minor_version = true
  depends_on                 = [azurerm_virtual_machine_data_disk_attachment.data_disk_orbital_rtstps_attach]
  #timeouts {
  #  create = "60m"
  #}
  settings                   = <<SETTINGS
    {
        "commandToExecute":"export AQUA_MI_ID=${azurerm_user_assigned_identity.uamiorbital.client_id} && export AQUA_TOOLS_SA=samrw && ./main_rtstps.sh > ./logfile.txt exit 0",
        "fileUris":["https://raw.githubusercontent.com/mattweale/azure-orbital-infrastructure/main/vm_configuration/mount_data_drive.sh",
                    "https://raw.githubusercontent.com/mattweale/azure-orbital-infrastructure/main/vm_configuration/mount_container.sh",
                    "https://raw.githubusercontent.com/mattweale/azure-orbital-infrastructure/main/vm_configuration/main_rtstps.sh",
                    "https://raw.githubusercontent.com/mattweale/azure-orbital-infrastructure/main/vm_configuration/rtstps_install.sh"]
    }
SETTINGS
  tags                       = var.tags
}