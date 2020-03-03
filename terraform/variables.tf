variable "service_principal_client_id" {
  type        = string
  description = "Client ID"
}

variable "service_principal_client_secret" {
  type        = string
  description = "Client Secret"
}

variable "resource_name_prefix" {
  type        = string
  description = "Resource prefix"
  default     = "kedaeh"
}

# Tags
variable "tag_env" {
  type        = string
  description = "The environment tag name"
  default     = "dev"
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
  default     = "keda-eventhub"
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

# Event Hubs (topics)
variable "rcvr_topic" {
  type        = string
  description = "Receiver topic name"
  default     = "receiver_topic"
}

# Event Hubs (consumer groups)
variable "rcvr_topic_consumer_group_name" {
  type        = string
  description = "Receiver topic consumer group name"
  default     = "group-receiver-topic"
}

# Event Hubs (partitions)
variable "rcvr_topic_partition_count" {
  description = "Event Hubs partition count for receiver_topic"
  default     = 10
}

# Event Hubs (message retention)
variable "rcvr_topic_message_retention" {
  description = "Event Hubs message retention for receiver_topic"
  default     = 1
}