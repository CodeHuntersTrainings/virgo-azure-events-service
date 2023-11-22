resource "azurerm_key_vault_secret" "cosmosdb-username" {
  count        = var.database-enabled ?  1 : 0

  name         = "cosmosdb-events-connection-string"
  value        = azurerm_cosmosdb_account.codehunters-cosmosdb-account[0].connection_strings[0]
  key_vault_id = azurerm_key_vault.codehunters-key-vault[0].id
}

resource "azurerm_key_vault_secret" "cosmosdb-password" {
  count        = var.database-enabled ?  1 : 0

  name         = "cosmosdb-events-password"
  value        = azurerm_cosmosdb_account.codehunters-cosmosdb-account[0].primary_key
  key_vault_id = azurerm_key_vault.codehunters-key-vault[0].id
}

