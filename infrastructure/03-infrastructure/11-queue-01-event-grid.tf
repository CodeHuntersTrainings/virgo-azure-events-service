resource "azurerm_eventgrid_topic" "codehunters-events-topic" {
  count               = var.queue-enabled ? 1 : 0

  name                = "codehunters-events"
  location            = azurerm_resource_group.codehunters-main-resource-group.location
  resource_group_name = azurerm_resource_group.codehunters-main-resource-group.name

  public_network_access_enabled = false

}

resource "azurerm_private_dns_zone" "codehunters-events-topic-private-endpoint-pdnsz" {
  count               = var.queue-enabled ? 1 : 0

  name                = "privatelink.eventgrid.azure.net"
  resource_group_name = azurerm_resource_group.codehunters-main-resource-group.name
}

resource "azurerm_private_endpoint" "codehunters-events-topic-private-endpoint" {
  count               = var.queue-enabled ? 1 : 0

  name                = "codehunters-event-grid-private-endpoint"
  location            = azurerm_resource_group.codehunters-main-resource-group.location
  resource_group_name = azurerm_resource_group.codehunters-main-resource-group.name

  subnet_id = azurerm_subnet.private-subnet[0].id

  private_service_connection {
    name                           = "eventgrid-connection"
    private_connection_resource_id = azurerm_eventgrid_topic.codehunters-events-topic[0].id
    is_manual_connection           = false
    subresource_names              = ["topic"] # Source: https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
  }

  private_dns_zone_group {
    name                 = "event-grid-private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.codehunters-events-topic-private-endpoint-pdnsz[0].id]
  }

}

resource "azurerm_private_dns_zone_virtual_network_link" "codehunters-pdnsz-linked-to-vnet" {
  count                 = var.queue-enabled ? 1 : 0

  name                  = "codehunters-pdnsz-to-vnet-link"
  resource_group_name = azurerm_resource_group.codehunters-main-resource-group.name
  private_dns_zone_name = azurerm_private_dns_zone.codehunters-events-topic-private-endpoint-pdnsz[0].name
  virtual_network_id    = azurerm_virtual_network.codehunters-vnet[0].id
  registration_enabled  = true
}

resource "azurerm_private_dns_a_record" "dns-a-record-for-private-endpoint" {
  count                 = var.queue-enabled ? 1 : 0

  name                = "codehunters-events.westeurope-1"
  zone_name           = azurerm_private_dns_zone.codehunters-events-topic-private-endpoint-pdnsz[0].name
  resource_group_name = azurerm_resource_group.codehunters-main-resource-group.name
  ttl                 = 10
  records             = [azurerm_private_endpoint.codehunters-events-topic-private-endpoint[0].private_service_connection.0.private_ip_address]
}
