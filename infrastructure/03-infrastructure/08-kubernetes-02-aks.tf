resource "azurerm_kubernetes_cluster" "codehunters-aks-cluster" {
  count               = var.kubernetes-enabled ? 1 : 0

  name                = "codehunters-training-aks"
  resource_group_name = azurerm_resource_group.codehunters-main-resource-group.name
  location            = azurerm_resource_group.codehunters-main-resource-group.location
  dns_prefix          = "codehuntersaks"

  # VMSS
  default_node_pool {
    name            = "codehunters"
    node_count      = 3
    vm_size         = "Standard_B2s"
    min_count       = 1
    max_count       = 5
    max_pods        = 30 #30 is the minimum

    enable_auto_scaling     = true
    vnet_subnet_id          = azurerm_subnet.private-subnet[0].id
    enable_node_public_ip   = false

  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    # The Azure Container Networking Interface (CNI) plugin, used for pod networking,
    # benefits from having its own subnet for efficient IP address management
    # PODs have different subnet from NODEs.
    network_plugin    = "azure"
    network_policy    = "azure"
    service_cidr      = "10.1.100.0/24"
    dns_service_ip    = "10.1.100.10"
    load_balancer_sku = "standard"
  }

}