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

# Outputs required for deploy.yaml

output "eventhub_namespace_conn_string_base64encoded" {
  value = base64encode(azurerm_eventhub_namespace.hubns.default_primary_connection_string) 
}

output "eventhub_namespace_name_base64encoded" {
  value = base64encode(azurerm_eventhub_namespace.hubns.name)
}

output "eventhub_namespace_name" {
  value = azurerm_eventhub_namespace.hubns.name
}

output "eventhub_consumergroup_name_base64encoded"{
  value = base64encode(azurerm_eventhub_consumer_group.group_rcvr_topic.name)
}

output "eventhub_consumergroup_name"{
  value = azurerm_eventhub_consumer_group.group_rcvr_topic.name
}

output "eventhub_name_base64encoded" {
  value = base64encode(azurerm_eventhub.rcvr_topic.name)
}

output "eventhub_name" {
  value = azurerm_eventhub.rcvr_topic.name
}

output "resource_group_name" {
  value = azurerm_resource_group.rg_keda.name
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks_app.name
}