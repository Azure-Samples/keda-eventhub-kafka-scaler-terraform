provider "azurerm" {
    version         = ">= 2.0"
    features {}
}

resource "azurerm_resource_group" "rg_keda_eventhub" {
    name     = var.resource_group_name
    location = var.location
}

resource "azurerm_container_registry" "acr" {
    name                = "${var.resource_name_prefix}acr"
    resource_group_name = var.resource_group_name
    location            = var.location
    sku                 = "Premium"
    admin_enabled       = true
}

resource "random_id" "log_analytics_workspace_name_suffix" {
    byte_length = 8
}

resource "azurerm_log_analytics_workspace" "aks_app_log_workspace" {
    # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
    name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
    location            = var.log_analytics_workspace_location
    resource_group_name = azurerm_resource_group.rg_keda_eventhub.name
    sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "aks_app_log_solution" {
    solution_name         = "ContainerInsights"
    location              = azurerm_log_analytics_workspace.aks_app_log_workspace.location
    resource_group_name   = azurerm_resource_group.rg_keda_eventhub.name
    workspace_resource_id = azurerm_log_analytics_workspace.aks_app_log_workspace.id
    workspace_name        = azurerm_log_analytics_workspace.aks_app_log_workspace.name

    plan {
        publisher = "Microsoft"
        product   = "OMSGallery/ContainerInsights"
    }
}

resource "azurerm_kubernetes_cluster" "aks_app" {
    name                = var.cluster_name
    location            = azurerm_resource_group.rg_keda_eventhub.location
    resource_group_name = azurerm_resource_group.rg_keda_eventhub.name
    dns_prefix          = var.dns_prefix

    default_node_pool {
        name            = "default"
        node_count      = var.node_count
        vm_size         = "Standard_F4s_v2"
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
        oms_agent {
        enabled                    = true
        log_analytics_workspace_id = azurerm_log_analytics_workspace.aks_app_log_workspace.id
        }
    }

    network_profile {
        network_plugin = "azure"
    }

    tags = {
        Environment = "Development"
    }
}

resource "azurerm_role_assignment" "acrpull_role_aks_app" {
    scope                            = var.resource_group_name
    role_definition_name             = "AcrPull"
    principal_id                     = var.service_principal_client_id
    skip_service_principal_aad_check = true
}

provider "helm" {
    version = ">= 0.7"

    kubernetes {
    host                   = azurerm_kubernetes_cluster.aks_app.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks_app.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.aks_app.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_app.kube_config.0.cluster_ca_certificate)
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