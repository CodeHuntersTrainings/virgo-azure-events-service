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
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

provider "azuread" {

}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.codehunters-aks-cluster[0].kube_config[0].host
    client_key             = base64decode(azurerm_kubernetes_cluster.codehunters-aks-cluster[0].kube_config[0].client_key)
    client_certificate     = base64decode(azurerm_kubernetes_cluster.codehunters-aks-cluster[0].kube_config[0].client_certificate)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.codehunters-aks-cluster[0].kube_config[0].cluster_ca_certificate)
  }
}