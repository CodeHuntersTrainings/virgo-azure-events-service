resource "azurerm_virtual_network" "codehunters-vnet" {
  count               = var.vnet-enabled ? 1 : 0

  name                = "codehunters-vnet"
  address_space       = ["10.0.0.0/16"]

  location            = azurerm_resource_group.codehunters-main-resource-group.location
  resource_group_name = azurerm_resource_group.codehunters-main-resource-group.name
}