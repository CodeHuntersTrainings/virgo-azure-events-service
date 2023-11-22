resource "azurerm_storage_account" "codehunters-queue-storage-account" {
  count                    = var.queue-enabled ? 1 : 0

  name                     = "codehuntersqueueevents"
  resource_group_name      = azurerm_resource_group.codehunters-main-resource-group.name
  location                 = azurerm_resource_group.codehunters-main-resource-group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
}

resource "azurerm_storage_queue" "codehunters-events-queue" {
  count                 = var.queue-enabled ? 1 : 0
  name                  = "eventsqueue"
  storage_account_name  = azurerm_storage_account.codehunters-queue-storage-account[0].name
}

resource "azurerm_role_assignment" "queue-storage-role-assigment" {
  count                            = var.queue-enabled ? 1 : 0

  principal_id                     = var.training-users
  role_definition_name             = "Contributor"
  scope                            = azurerm_storage_account.codehunters-queue-storage-account[0].id
  skip_service_principal_aad_check = false # FALSE for Users and Groups
}