terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.78.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.45.0"
    }
  }
}

provider "azurerm" {
  features { }
}

provider "azuread" {

}

provider "random" {

}