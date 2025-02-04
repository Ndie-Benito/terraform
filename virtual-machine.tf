

resource "azurerm_resource_group" "rg_benito" {
  name     = "rgvm"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet_benito" {
  name                = "vn_benito"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_benito.location
  resource_group_name = azurerm_resource_group.rg_benito.name
}

resource "azurerm_subnet" "subnet1" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg_benito.name
  virtual_network_name = azurerm_virtual_network.vnet_benito.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "vm-nic"
  location            = azurerm_resource_group.rg_benito.location
  resource_group_name = azurerm_resource_group.rg_benito.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "benito_windows" {
  name                = "benito-machine"
  resource_group_name = azurerm_resource_group.rg_benito.name
  location            = azurerm_resource_group.rg_benito.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
