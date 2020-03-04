output "client_key" {
  value = azurerm_kubernetes_cluster.aks_app.kube_config.0.client_key
  sensitive   = true
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks_app.kube_config.0.client_certificate
  sensitive   = true
}

output "admin_username" {
  value = azurerm_container_registry.acr.admin_username
}

output "admin_password" {
  value = azurerm_container_registry.acr.admin_password
  sensitive   = true
}

output "acr_name" {
  value = azurerm_container_registry.acr.name
}

output "cluster_ca_certificate" {
  value = azurerm_kubernetes_cluster.aks_app.kube_config.0.cluster_ca_certificate
  sensitive   = true
}

output "cluster_username" {
  value = azurerm_kubernetes_cluster.aks_app.kube_config.0.username
}

output "cluster_password" {
  value = azurerm_kubernetes_cluster.aks_app.kube_config.0.password
  sensitive   = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks_app.kube_config_raw
  sensitive   = true
}

output "host" {
  value = azurerm_kubernetes_cluster.aks_app.kube_config.0.host
}