output "client_key" {
  value = azurerm_kubernetes_cluster.aks_app.kube_config.0.client_key
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks_app.kube_config.0.client_certificate
}

output "admin_username" {
  value = azurerm_container_registry.acr.admin_username
}

output "admin_password" {
  value = azurerm_container_registry.acr.admin_password
}

output "acr_name" {
  value = azurerm_container_registry.acr.name
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.aks_app.kube_config.0.cluster_ca_certificate
}

output "cluster_username" {
  value = azurerm_kubernetes_cluster.aks_app.kube_config.0.username
}

output "cluster_password" {
  value = azurerm_kubernetes_cluster.aks_app.kube_config.0.password
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_app.kube_config_raw
}

output "host" {
  value = azurerm_kubernetes_cluster.aks_app.kube_config.0.host
}