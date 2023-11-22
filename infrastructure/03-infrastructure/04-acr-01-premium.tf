resource "azurerm_container_registry" "codehunters-premium-acr" {
  count               = var.acr-enabled && !var.kubernetes-enabled ? 1 : 0

  name                = "codehunterstrainingacr"
  resource_group_name = azurerm_resource_group.codehunters-main-resource-group.name
  location            = azurerm_resource_group.codehunters-main-resource-group.location
  sku                 = "Premium"
  admin_enabled       = false

  trust_policy {
    enabled = false
  }

  retention_policy {
    enabled   = true
    days      = 3
  }
}

resource "azurerm_role_assignment" "acr-role-assigment-to-premium-acr" {
  count                            = var.acr-enabled && !var.kubernetes-enabled ? 1 : 0

  principal_id                     = var.training-users
  role_definition_name             = "Contributor"
  scope                            = azurerm_container_registry.codehunters-premium-acr[0].id
  skip_service_principal_aad_check = false # FALSE for Users and Groups
}