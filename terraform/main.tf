provider "azurerm" {
  version = ">= 2.0"
  features {}
}

# Azure resource group

resource "azurerm_resource_group" "rg_keda" {
  name     = var.resource_group_name
  location = var.location
}

# Azure container registry

resource "azurerm_container_registry" "acr" {
  name                = "${var.resource_name_prefix}acr"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Premium"
  admin_enabled       = true
}

# AKS cluster

resource "azurerm_kubernetes_cluster" "aks_app" {
  name                = var.cluster_name
  location            = azurerm_resource_group.rg_keda.location
  resource_group_name = azurerm_resource_group.rg_keda.name
  dns_prefix          = var.dns_prefix

  default_node_pool {
    name                = "default"
    node_count          = var.node_count
    vm_size             = var.vm_size
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = true
    min_count           = 3
    max_count           = 20
    max_pods            = 100
  }

  service_principal {
    client_id     = var.service_principal_client_id
    client_secret = var.service_principal_client_secret
  }

  addon_profile {
    kube_dashboard {
      enabled = true
    }
  }

  network_profile {
    network_plugin = "azure"
  }

  tags = {
    Environment = var.tag_env
  }
}

resource "azurerm_role_assignment" "acrpull_role_aks_app" {
  scope                            = azurerm_resource_group.rg_keda.id
  role_definition_name             = "AcrPull"
  principal_id                     = var.service_principal_client_id
  skip_service_principal_aad_check = true
}

# Helm and KEDA installation

provider "helm" {
  version = ">= 0.7"

  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks_app.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks_app.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks_app.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_app.kube_config.0.cluster_ca_certificate)
    load_config_file       = false
  }
}

resource "helm_release" "keda" {
  name       = "keda"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  namespace  = "default"

  devel = "true"

  set {
    name  = "logLevel"
    value = "debug"
  }
}

# Event Hubs

resource "azurerm_eventhub_namespace" "hubns" {
  name                     = "${var.resource_name_prefix}-hubns-${var.tag_env}"
  resource_group_name      = azurerm_resource_group.rg_keda.name
  location                 = var.location
  sku                      = "Standard"
  capacity                 = var.eventhub_capacity
  auto_inflate_enabled     = true
  maximum_throughput_units = 20

  tags = {
    environment = var.tag_env
  }
}

# Consumer topic

resource "azurerm_eventhub" "rcvr_topic" {
  name                = var.rcvr_topic
  namespace_name      = azurerm_eventhub_namespace.hubns.name
  resource_group_name = azurerm_eventhub_namespace.hubns.resource_group_name
  partition_count     = var.rcvr_topic_partition_count
  message_retention   = var.rcvr_topic_message_retention
}

resource "azurerm_eventhub_consumer_group" "group_rcvr_topic" {
  name                = var.rcvr_topic_consumer_group_name
  namespace_name      = azurerm_eventhub_namespace.hubns.name
  eventhub_name       = azurerm_eventhub.rcvr_topic.name
  resource_group_name = azurerm_eventhub_namespace.hubns.resource_group_name
}
