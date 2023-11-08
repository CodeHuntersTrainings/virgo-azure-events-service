data "azurerm_subscription" "primary" {
}

data "azuread_client_config" "current" {
}

resource "azuread_application" "codehunters-application" {
  display_name = "codehunters-training-sp"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_application_password" "codehunters-application-password" {
  application_object_id = azuread_application.codehunters-application.object_id
}

resource "azuread_service_principal" "codehunters-service-principal" {
  client_id                     = azuread_application.codehunters-application.client_id
  app_role_assignment_required  = false
  owners                        = [data.azuread_client_config.current.object_id]
}

resource "azurerm_role_assignment" "codehunters-application-role-assignment-to-subscription" {
  scope                = data.azurerm_subscription.primary.id
  role_definition_name = "Owner" # Contributor role is not enough because Role Assignment is necessary
  principal_id         = azuread_service_principal.codehunters-service-principal.object_id
}

