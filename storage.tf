
resource "azurerm_resource_group" "rg" {
  name     = "my-resource-group"
  location = "East US" # Change selon ta région Azure
}

resource "azurerm_storage_account" "storage" {
  name                     = "storage47ben" # Doit être unique globalement
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS" # Options : LRS, GRS, ZRS, RAGRS

  tags = {
    environment = "dev"
  }
}

/*resource "azurerm_storage_container" "container" {
  name                  = "mycontainer47ben"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private" # Options : private, blob, container
}

output "storage_account_name" {
  value = azurerm_storage_account.storage.name
}

output "storage_container_name" {
  value = azurerm_storage_container.container.name
}*/
