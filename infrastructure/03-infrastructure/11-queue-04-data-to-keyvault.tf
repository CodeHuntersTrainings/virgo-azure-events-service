resource "azurerm_key_vault_secret" "queue-access-token" {
  count        = var.queue-enabled ?  1 : 0

  name         = "events-topic-access-key"
  value        = azurerm_eventgrid_topic.codehunters-events-topic[0].primary_access_key
  key_vault_id = azurerm_key_vault.codehunters-key-vault[0].id
}

