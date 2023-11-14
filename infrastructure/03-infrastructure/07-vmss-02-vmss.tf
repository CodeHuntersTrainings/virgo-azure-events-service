resource "azurerm_linux_virtual_machine_scale_set" "codehunters-vmss" {
  count               = var.vmss-enabled ? 1 : 0

  name                = "codehunters-vmss"
  resource_group_name = azurerm_resource_group.codehunters-main-resource-group.name
  location            = azurerm_resource_group.codehunters-main-resource-group.location
  # health_probe_id     = azurerm_lb_probe.codehunters-load-balancer-health-probe-spring-boot[0].id

  admin_username      = "azureuser"
  admin_password      = "HX3SsU4y3" # In production this must be generated and stored in KeyVault

  sku                 = "Standard_B1s"
  instances           = 1

  disable_password_authentication       = false

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name        = "vmss-nic"
    primary     = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.private-subnet[0].id

      # load_balancer_backend_address_pool_ids = [azurerm_lb_backend_address_pool.codehunters-load-balancer-pool[0].id]
    }
  }

  # custom_data = base64encode(
  #   <<-SCRIPT
  #   #!/bin/bash
  #   # Install Docker
  #   sudo apt-get update
  #   sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
  #   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  #   sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  #   sudo apt-get update
  #   sudo apt-get install -y docker-ce
  #   # Start a Docker container (example)
  #   sudo docker run -d -p 80:80 nginx
  #   SCRIPT
  # )

}