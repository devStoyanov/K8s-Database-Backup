output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.k8s.name
}

output "aks_resource_group" {
  value = azurerm_resource_group.aks-rg.name
}

output "id" {
  value = azurerm_kubernetes_cluster.k8s.id
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.k8s.kube_config_raw
}

output "client_key" {
  value = azurerm_kubernetes_cluster.k8s.kube_config.0.client_key
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.k8s.kube_config.0.client_certificate
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.k8s.kube_config.0.cluster_ca_certificate
}

output "host" {
  value = azurerm_kubernetes_cluster.k8s.kube_config.0.host
}