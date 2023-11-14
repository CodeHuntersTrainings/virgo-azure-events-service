resource "azurerm_subnet" "public-subnet" {
  count                   = var.vnet-enabled ? 1 : 0

  virtual_network_name    = azurerm_virtual_network.codehunters-vnet[0].name
  name                    = "codehunters-public-subnet"
  resource_group_name     = azurerm_resource_group.codehunters-main-resource-group.name
  address_prefixes        = [var.public-subnet]
}

resource "azurerm_subnet" "private-subnet" {
  count                   = var.vnet-enabled ? 1 : 0

  virtual_network_name    = azurerm_virtual_network.codehunters-vnet[0].name
  name                    = "codehunters-private-subnet"
  resource_group_name     = azurerm_resource_group.codehunters-main-resource-group.name
  address_prefixes        = [var.private-subnet]

  service_endpoints = [
    "Microsoft.AzureCosmosDB",
    "Microsoft.ContainerRegistry",
    "Microsoft.KeyVault",
    "Microsoft.Storage"
  ]
}