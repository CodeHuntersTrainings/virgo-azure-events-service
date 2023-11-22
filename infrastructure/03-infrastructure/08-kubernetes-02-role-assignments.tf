resource "azurerm_role_assignment" "aks-to-acr" {
  count                           = var.kubernetes-enabled ? 1 : 0

  principal_id                     = azurerm_kubernetes_cluster.codehunters-aks-cluster[0].kubelet_identity[0].object_id
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.codehunters-standard-acr[0].id
  skip_service_principal_aad_check = true # FALSE for Users
}

# resource "azurerm_role_assignment" "students-to-aks-as-admin" {
#   count                            = var.kubernetes-enabled ? 1 : 0
#
#   principal_id                     = var.training-users
#   role_definition_name             = "Azure Kubernetes Service Cluster Admin Role"
#   scope                            = azurerm_kubernetes_cluster.codehunters-aks-cluster[0].id
# }

resource "azurerm_role_assignment" "students-to-aks-as-user" {
  count                            = var.kubernetes-enabled ? 1 : 0

  principal_id                     = var.training-users
  role_definition_name             = "Azure Kubernetes Service Cluster User Role"
  scope                            = azurerm_kubernetes_cluster.codehunters-aks-cluster[0].id
}