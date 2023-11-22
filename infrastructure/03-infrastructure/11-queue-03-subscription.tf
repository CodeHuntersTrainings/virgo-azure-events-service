resource "azurerm_eventgrid_event_subscription" "queue-storage-to-event-grid-topic" {
  count    = var.queue-enabled ? 1 : 0

  name     = "events-subscription"
  scope    = azurerm_eventgrid_topic.codehunters-events-topic[0].id

  event_delivery_schema    = "EventGridSchema"

  included_event_types     = [
    "Microsoft.Resources.ResourceWriteSuccess",
    "Microsoft.Resources.ResourceWriteFailure",
    "Microsoft.Resources.ResourceWriteCancel",
    "Microsoft.Resources.ResourceDeleteSuccess",
    "Microsoft.Resources.ResourceDeleteFailure",
    "Microsoft.Resources.ResourceDeleteCancel",
    "Microsoft.Resources.ResourceActionSuccess",
    "Microsoft.Resources.ResourceActionFailure",
    "Microsoft.Resources.ResourceActionCancel"
  ]

  storage_queue_endpoint {
    storage_account_id = azurerm_storage_account.codehunters-queue-storage-account[0].id
    queue_name         = azurerm_storage_queue.codehunters-events-queue[0].name
  }
}
