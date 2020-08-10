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

variable "system_name" {
  type        = string
  description = "Name to use for the data science cluster being created"
}

variable "environment" {
  type        = string
  description = "Current Environment to provision within"
}

variable "default_tags" {
  type        = map(string)
  description = "Collection of default tags to apply to all resources"
}

variable "subnet_cidrs" {
  type        = list(string)
  description = "The subnet CIDRs the Grafana server should live within."
}

//variable "topic" {
//  type        = string
//  description = "The eventhub mqtt topic to consume."
//}
//variable "topic_consumer_group" {
//  type        = string
//  description = "The consumer group to be used by the eventhub client."
//}
//variable "message_type" {
//  type        = string
//  description = "The message record type to process.  See https://messaging.networksurvey.app/"
//}
//variable "message_version" {
//  type        = string
//  description = "The version specifier of the message the instance should handle. See https://messaging.networksurvey.app/ and https://www.python.org/dev/peps/pep-0440/#version-specifiers"
//}
variable "db_host" {
  type        = string
  description = "The database fully qualified host name"
}
variable "db_port" {
  type        = string
  description = "The database connection port"
  default     = "5432"
}
variable "db_name" {
  type        = string
  description = "The database name for the database connection"
}
variable "db_user" {
  type        = string
  description = "The username for the database connection"
}
variable "db_password" {
  type        = string
  description = "The password for the database connection"
}
variable "db_schema" {
  type        = string
  description = "The database schema being used for storing data points."
  default     = "public"
}
variable "eventhub_key" {
  type        = string
  description = "The access key for eventhub"
}
variable "eventhub_namespace" {
  type        = string
  description = "The fully qualified eventhub namespace"
}
variable "eventhub_shared_access_policy" {
  type        = string
  description = "The name of the eventhub shared access policy used to authenticate to eventhub"
}
variable "checkpoint_store_connection_str" {
  type        = string
  description = "[Optional] The azure blob container connection string is checkpoiint storage is being used."
  default     = ""
}
variable "checkpoint_store_container" {
  type        = string
  description = "[Optional] The azure blob container to be used for eventhub checkpoint storage."
  default     = ""
}
variable "buffer_size" {
  type        = string
  description = "Controls the number of messages that are buffered before writing to the database"
  default     = "1"
}
variable "log_level" {
  type        = string
  description = "The python loggin level to use at runtime. Must be DEBUG, INFO, WARN, ERROR, or FATAL"
  default     = "INFO"
}