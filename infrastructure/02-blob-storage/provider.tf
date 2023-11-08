terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.78.0"
    }
  }
}

#azurerm = azure resource manager
provider "azurerm" {
  features {}

}