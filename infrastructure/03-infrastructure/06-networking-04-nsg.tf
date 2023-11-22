# Network Security Group - Public
resource "azurerm_network_security_group" "codehunters-public-nsg" {
  count                   = var.vnet-enabled ? 1 : 0

  name                    = "codehunters-public-nsg"
  location                = azurerm_resource_group.codehunters-main-resource-group.location
  resource_group_name     = azurerm_resource_group.codehunters-main-resource-group.name

  security_rule {
    name                          = "sec-rules-01"
    access                        = "Allow"
    direction                     = "Inbound"
    priority                      = 1000
    protocol                      = "Tcp"
    destination_address_prefix    = "*"
    destination_port_ranges       = ["22", "80", "443", "8080"]
    source_port_range             = "*"
    source_address_prefix         = "*"
  }
}

# Public subnet is protected by a NSG
resource "azurerm_subnet_network_security_group_association" "nsg-to-public-subnets" {
  count                         = var.vnet-enabled ? 1 : 0

  network_security_group_id     = azurerm_network_security_group.codehunters-public-nsg[0].id
  subnet_id                     = azurerm_subnet.public-subnet[0].id
}

# Network Security Group - Private
resource "azurerm_network_security_group" "codehunters-private-nsg" {
  count                   = var.vnet-enabled ? 1 : 0

  name                    = "codehunters-private-nsg"
  location                = azurerm_resource_group.codehunters-main-resource-group.location
  resource_group_name     = azurerm_resource_group.codehunters-main-resource-group.name

  security_rule {
    name                          = "sec-rules-01"
    access                        = "Allow"
    direction                     = "Inbound"
    priority                      = 1000
    protocol                      = "Tcp"
    destination_address_prefix    = "*"
    destination_port_ranges       = ["22", "80", "443", "8080"]
    source_port_range             = "*"
    source_address_prefix         = var.kubernetes-enabled ? "*" : azurerm_subnet.public-subnet[0].address_prefixes[0]
  }

}

# Private subnet is protected by a NSG
resource "azurerm_subnet_network_security_group_association" "nsg-to-private-subnets" {
  count                         = var.vnet-enabled ? 1 : 0

  network_security_group_id     = azurerm_network_security_group.codehunters-private-nsg[0].id
  subnet_id                     = azurerm_subnet.private-subnet[count.index].id
}