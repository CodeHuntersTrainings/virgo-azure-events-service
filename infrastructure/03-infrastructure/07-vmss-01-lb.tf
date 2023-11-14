# resource "azurerm_public_ip" "codehunters-load-balancer-ip" {
#   count               = var.vmss-enabled ? 1 : 0
#
#   name                = "codehunters-load-balancer-ip"
#   resource_group_name = azurerm_resource_group.codehunters-main-resource-group.name
#   location            = azurerm_resource_group.codehunters-main-resource-group.location
#   allocation_method   = "Static"
# }
#
# resource "azurerm_lb" "codehunters-load-balancer" {
#   count               = var.vmss-enabled ? 1 : 0
#
#   name                = "codehunters-load-balancer"
#   resource_group_name = azurerm_resource_group.codehunters-main-resource-group.name
#   location            = azurerm_resource_group.codehunters-main-resource-group.location
#
#   frontend_ip_configuration {
#     name                 = "CodeHuntersLoadBalancerPublicIPAddress"
#     public_ip_address_id = azurerm_public_ip.codehunters-load-balancer-ip[0].id
#   }
#
# }
#
# resource "azurerm_lb_backend_address_pool" "codehunters-load-balancer-pool" {
#   count               = var.vmss-enabled ? 1 : 0
#
#   name                = "lbBackendPool"
#   loadbalancer_id     = azurerm_lb.codehunters-load-balancer[0].id
# }
#
# resource "azurerm_lb_probe" "codehunters-load-balancer-health-probe-spring-boot" {
#   count               = var.vmss-enabled ? 1 : 0
#
#   name                = "codehunters-load-balancer-health-probe"
#   loadbalancer_id     = azurerm_lb.codehunters-load-balancer[0].id
#   port                = 80
#   protocol            = "Tcp"
#   interval_in_seconds = 5
#   number_of_probes    = 2
# }