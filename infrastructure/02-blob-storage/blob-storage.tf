resource "azurerm_resource_group" "codehunters-blob-storage-resource-group" {
  name     = "codehunters-storages"
  location = "westeurope"
}

resource "azurerm_storage_account" "codehunters-blob-storage-account" {
  name                     = "codehuntersstorageacc"
  resource_group_name      = azurerm_resource_group.codehunters-blob-storage-resource-group.name
  location                 = azurerm_resource_group.codehunters-blob-storage-resource-group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "BlobStorage"
}

resource "azurerm_storage_container" "codehunters-blob-storage-container" {
  name                  = "blobcontainers"
  storage_account_name  = azurerm_storage_account.codehunters-blob-storage-account.name
}
