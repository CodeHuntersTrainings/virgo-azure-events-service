resource "azurerm_virtual_network" "codehunters-vnet" {
  name                = "czirjak-codehunters-vnet"
  address_space       = ["10.11.0.0/16"]

  location            = azurerm_resource_group.vnet-resource-group.location
  resource_group_name = azurerm_resource_group.vnet-resource-group.name
}

