
resource "azurerm_resource_group" "rg_benito" {
  name     = "rg_benito"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet_benito" {
  name                = "vnet_benito"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_benito.location
  resource_group_name = azurerm_resource_group.rg_benito.name
}

resource "azurerm_subnet" "subnet_benito" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg_benito.name
  virtual_network_name = azurerm_virtual_network.vnet_benito.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic_benito" {
  name                = "benito-nic"
  location            = azurerm_resource_group.rg_benito.location
  resource_group_name = azurerm_resource_group.rg_benito.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_benito.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm_benito" {
  name                = "benito-machine"
  resource_group_name = azurerm_resource_group.rg_benito.name
  location            = azurerm_resource_group.rg_benito.location
  size                = "Standard_F2"
  admin_username      = var.admin_username
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.nic_benito.id,
  ]

admin_password = var.admin_password

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

