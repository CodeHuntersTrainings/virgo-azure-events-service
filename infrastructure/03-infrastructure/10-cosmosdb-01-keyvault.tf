resource "azurerm_key_vault" "codehunters-key-vault" {
  count                       = var.database-enabled || var.queue-enabled ?  1 : 0

  name                        = "codehunterskeyvault"
  location                    = azurerm_resource_group.codehunters-main-resource-group.location
  resource_group_name         = azurerm_resource_group.codehunters-main-resource-group.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.client.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false # In production this must be true

  sku_name = "standard"

  access_policy {
    object_id = "b05cbda0-ffeb-4ced-966a-f0970726a7ac" #czirjak
    tenant_id = data.azurerm_client_config.client.tenant_id

    secret_permissions = [
      "Get",
      "Delete",
      "List",
      "Set"
    ]
  }

  access_policy {
    object_id = var.training-users #training-group
    tenant_id = data.azurerm_client_config.client.tenant_id

    secret_permissions = [
      "Get",
      "Delete",
      "List",
      "Set"
    ]
  }

  access_policy {
    object_id = data.azurerm_client_config.client.object_id #service-principal
    tenant_id = data.azurerm_client_config.client.tenant_id

    secret_permissions = [
      "Backup", "Delete", "Get", "List", "Purge", "Recover", "Restore", "Set"
    ]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.client.tenant_id
    object_id    = azurerm_kubernetes_cluster.codehunters-aks-cluster[0].key_vault_secrets_provider[0].secret_identity[0].object_id

    secret_permissions = [
      "Get",
      "List"
    ]
  }
}