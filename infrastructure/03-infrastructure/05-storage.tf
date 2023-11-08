resource "azurerm_storage_account" "codehunters-blob-storage-account" {
  count                    = var.storage-enabled ? 1 : 0
  name                     = "codehuntersevents"
  resource_group_name      = azurerm_resource_group.codehunters-main-resource-group.name
  location                 = azurerm_resource_group.codehunters-main-resource-group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

resource "azurerm_storage_container" "codehunters-blob-storage-container" {
  count                 = var.storage-enabled ? 1 : 0
  name                  = "events"
  storage_account_name  = azurerm_storage_account.codehunters-blob-storage-account[0].name
}

resource "azurerm_role_assignment" "storage-role-assigment" {
  count                            = var.storage-enabled ? 1 : 0

  principal_id                     = var.training-users
  role_definition_name             = "Contributor"
  scope                            = azurerm_storage_account.codehunters-blob-storage-account[0].id
  skip_service_principal_aad_check = false # FALSE for Users and Groups
}