terraform {
  backend "azurerm" {
    resource_group_name       = "codehunters-storages"
    storage_account_name      = "codehuntersstorageacc"
    container_name            = "blobcontainers"
    key                       = "codehunters.training.terraform.tfstate"
  }
}
