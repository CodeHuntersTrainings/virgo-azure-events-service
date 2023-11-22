resource "azurerm_cosmosdb_account" "codehunters-cosmosdb-account" {
  count               = var.database-enabled ?  1 : 0

  name                = "codehunters-cosmosdb"
  location            = azurerm_resource_group.codehunters-main-resource-group.location
  resource_group_name = azurerm_resource_group.codehunters-main-resource-group.name
  offer_type          = "Standard"
  kind                = "MongoDB"
  enable_free_tier    = true

  enable_automatic_failover = false # In production this must be true

  consistency_policy {
    consistency_level       = "Eventual" # The Consistency Level to use for this CosmosDB Account - can be either BoundedStaleness, Eventual, Session, Strong or ConsistentPrefix
  }

  geo_location {
    location          = "westeurope"
    failover_priority = 0 # total number of regions - 1
  }

  # ip_range_filter = "..."
  # public_network_access_enabled = false
  is_virtual_network_filter_enabled = true
  virtual_network_rule {
    id = azurerm_subnet.private-subnet[0].id
  }

}

resource "azurerm_cosmosdb_mongo_database" "codehunters-cosmosdb-mongodb-database" {
  count               = var.database-enabled ?  1 : 0

  name                = "events-service"
  resource_group_name = azurerm_resource_group.codehunters-main-resource-group.name
  account_name        = azurerm_cosmosdb_account.codehunters-cosmosdb-account[0].name
}

resource "azurerm_cosmosdb_mongo_collection" "codehunters-events-collection" {
  count               = var.database-enabled ?  1 : 0

  name                = "events"
  resource_group_name = azurerm_resource_group.codehunters-main-resource-group.name
  account_name        = azurerm_cosmosdb_account.codehunters-cosmosdb-account[0].name
  database_name       = azurerm_cosmosdb_mongo_database.codehunters-cosmosdb-mongodb-database[0].name
  default_ttl_seconds = "777"
  shard_key           = "eventId"
  throughput          = 400

  index {
    keys   = ["_id"]
    unique = true
  }

}

resource "azurerm_role_assignment" "cosmos-role-assigment" {
  count                            = var.database-enabled ?  1 : 0

  principal_id                     = var.training-users
  role_definition_name             = "Contributor"
  scope                            = azurerm_cosmosdb_account.codehunters-cosmosdb-account[0].id
  skip_service_principal_aad_check = false # FALSE for Users and Groups
}


