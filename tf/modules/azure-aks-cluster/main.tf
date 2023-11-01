resource "azurerm_resource_group" "aks-rg" {
  name     = "${var.prefix}-k8s-resources"
  location = var.location

  tags = {
    environment = "dev"
  }
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = "${var.prefix}-k8s"
  location            = azurerm_resource_group.aks-rg.location
  resource_group_name = azurerm_resource_group.aks-rg.name
  dns_prefix          = "${var.prefix}-k8s"

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = "Standard_B2s"

    tags = {
      environment = "dev"
    }
  }

  identity {
    type = "SystemAssigned"
  }
}

