terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.63.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
}


resource "azurerm_resource_group" "RG-AKS" {
  name     = "AKS-RG"
  location = "West Europe"
}

resource "azurerm_kubernetes_cluster" "Res-Aks" {
  name                = "AKS"
  location            = azurerm_resource_group.RG-AKS.location
  resource_group_name = azurerm_resource_group.RG-AKS.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
  addon_profile {
    http_application_routing {
      enabled = true
    }
  }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.Res-Aks.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.Res-Aks.kube_config_raw
}