# Create public IP
resource "azurerm_public_ip" "codehunters-nat-gateway-public-ip" {
  count               = var.vnet-enabled && !var.kubernetes-enabled ? 1 : 0

  name                = "codehunters-ngw-public-ip"
  location            = azurerm_resource_group.codehunters-main-resource-group.location
  resource_group_name = azurerm_resource_group.codehunters-main-resource-group.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = [1]
}

#Nat Gateway
resource "azurerm_nat_gateway" "codehunters-nat-gateway" {
  count                   = var.vnet-enabled && !var.kubernetes-enabled ? 1 : 0

  name                    = "codehunters-nat-gateway"
  location                = azurerm_resource_group.codehunters-main-resource-group.location
  resource_group_name     = azurerm_resource_group.codehunters-main-resource-group.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = [1] # The resource type 'natGateways' does not support multiple availability zones.
}

# Nat - Public IP Association
resource "azurerm_nat_gateway_public_ip_association" "public-ip-to-natgw" {
  count                = var.vnet-enabled && !var.kubernetes-enabled ? 1 : 0

  nat_gateway_id       = azurerm_nat_gateway.codehunters-nat-gateway[0].id
  public_ip_address_id = azurerm_public_ip.codehunters-nat-gateway-public-ip[0].id
}

# NAT - Subnets association
resource "azurerm_subnet_nat_gateway_association" "private-subnets-to-natgw" {
  count          = var.vnet-enabled && !var.kubernetes-enabled ? 1 : 0

  subnet_id      = azurerm_subnet.private-subnet[0].id
  nat_gateway_id = azurerm_nat_gateway.codehunters-nat-gateway[0].id
}