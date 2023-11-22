resource "azurerm_container_registry" "codehunters-standard-acr" {
  count               = var.acr-enabled && var.kubernetes-enabled ? 1 : 0

  name                = "codehunterstrainingacr"
  resource_group_name = azurerm_resource_group.codehunters-main-resource-group.name
  location            = azurerm_resource_group.codehunters-main-resource-group.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_role_assignment" "acr-role-assigment-to-standard-acr" {
  count                            = var.acr-enabled && var.kubernetes-enabled ? 1 : 0

  principal_id                     = var.training-users
  role_definition_name             = "Contributor"
  scope                            = azurerm_container_registry.codehunters-standard-acr[0].id
  skip_service_principal_aad_check = false # FALSE for Users and Groups
}