variable "service_principal_client_id" {
    type        = string
    description = "Client ID"
    default = "f34a072c-e17e-4cc2-a8a1-eb719cacddcc"
}

variable "service_principal_client_secret" {
    type        = string
    description = "Client Secret"
    default = "0d826132-1e0e-4d5f-9ea1-1fcd5619094d"
}

variable "resource_name_prefix" {
    type        = string
    description = "Resource prefix"
    default     = "kedaeh"
}

variable "node_count" {
    default = 3
}

variable "dns_prefix" {
    default = "keda-cluster"
}

variable cluster_name {
    default = "keda-cluster"
}

variable resource_group_name {
    type        = string
    description = "Resource group name"
    default = "keda-eventhub"
}

variable location {
    type        = string
    description = "Azure location where the infrastructure will be provisioned"
    default     = "eastus"
}

variable log_analytics_workspace_name {
    default = "LogAnalyticsWorkspaceKeda"
}

# refer https://azure.microsoft.com/global-infrastructure/services/?products=monitor for log analytics available regions
variable log_analytics_workspace_location {
    default = "eastus"
}

# refer https://azure.microsoft.com/pricing/details/monitor/ for log analytics pricing 
variable log_analytics_workspace_sku {
    default = "PerGB2018"
}