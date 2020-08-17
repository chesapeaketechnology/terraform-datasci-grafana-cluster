variable "resource_group_name" {
  type        = string
  description = "Azure resource group in which to deploy"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of Azure virtual network"
}

variable "location" {
  type        = string
  description = "Region to provision resources in"
}

variable "cluster_name" {
  type        = string
  description = "Name to use for the data science cluster being created"
}

variable "environment" {
  type        = string
  description = "Current Environment to provision within"
}

variable "grafana_admin_user" {
  type = string
  description = "The username for the grafana administrative user account"
}

variable "grafana_port" {
  type = number
  description = "The port grafana should run on."
  default=3000
}

variable "network_profile_id" {
  type        = string
  description = "Name of the network profile in which to create the container"
}

variable "subnet_start_address" {
  type = string
  description = "The starting address in the subnet cidr"
}

variable "subnet_end_address" {
  type = string
  description = "The ending address in the subnet cidr"
}

variable "topics"{
  type        = set(string)
  description = "List of eventhubs to create under this eventhubs space"
}

variable "eventhub_keys" {
  type        = list(string)
  description = "The access keys for eventhub; ordered the same as the topics."
}
variable "eventhub_namespace" {
  type        = string
  description = "The fully qualified eventhub namespace"
}
variable "eventhub_shared_access_policies" {
  type        = list(string)
  description = "A list of names of the eventhub shared access policy used to authenticate to eventhub; ordered the same as the topics."
}

variable "default_tags" {
  type        = map(string)
  description = "Collection of default tags to apply to all resources"
}