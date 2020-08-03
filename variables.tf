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

variable "subnet_cidr" {
  type        = string
  description = "The subnet CIDRs to use for the Grafana servers"
  default     = "10.0.11.0/24"
}

variable "subnet_start_address" {
  type = string
  description = "The starting address in the subnet cidr"
}

variable "subnet_end_address" {
  type = string
  description = "The ending address in the subnet cidr"
}

variable "default_tags" {
  type        = map(string)
  description = "Collection of default tags to apply to all resources"
}