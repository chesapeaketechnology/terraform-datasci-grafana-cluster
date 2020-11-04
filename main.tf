provider "azurerm" {
  version = "~> 2.18.0"
  features {}
  disable_terraform_partner_id = true
  skip_provider_registration = true
}

resource "null_resource" "grafana_dependency" {
  depends_on = [var.grafana_depends_on]
  triggers   = {
    value = "${length(var.grafana_depends_on)}"
  }
}

resource "random_password" "grafana_data_password" {
  length = 16
  special = true
}

resource "random_password" "datasci_data_password" {
  length = 16
  special = true
}

resource "random_password" "grafana_admin_password" {
  length = 16
  special = true
}

module "grafana-data" {
  source               = "./modules/grafana-data"
  resource_group_name  = var.resource_group_name
  cluster_name         = var.cluster_name
  environment          = var.environment
  default_tags         = var.default_tags
  location             = var.location
  administrator_login = "grafana"
  administrator_password = random_password.grafana_data_password.result
  allow_access_from = [{
    start_address     = var.subnet_start_address
    end_address       = var.subnet_end_address
  },{
    start_address     = "0.0.0.0"
    end_address       = "0.0.0.0"
  }]
}

module "datasci-data" {
  source               = "./modules/datasci-data"
  resource_group_name  = var.resource_group_name
  cluster_name         = var.cluster_name
  environment          = var.environment
  location             = var.location
  default_tags         = var.default_tags
  administrator_login = "postgres"
  administrator_password = random_password.datasci_data_password.result
  allow_access_from = [{
    start_address     = var.subnet_start_address
    end_address       = var.subnet_end_address
  },{
    start_address     = "0.0.0.0"
    end_address       = "0.0.0.0"
  }]
}

module "grafana-server" {
  source               = "github.com/chesapeaketechnology/terraform-grafana?ref=v0.9.1"
  resource_group_name  = var.resource_group_name
  system_name          = var.cluster_name
  location             = var.location
  environment          = var.environment
  default_tags         = var.default_tags
  grafana_admin_user   = var.grafana_admin_user
  grafana_admin_password = random_password.grafana_admin_password.result
  grafana_db_type      = "postgres"
  grafana_db_host      = module.grafana-data.server_fqdn
  grafana_db_ssl_mode  = "require"
  grafana_db_username  = "${module.grafana-data.administrator_login}@${module.grafana-data.server_name}"
  grafana_db_password  = module.grafana-data.administrator_password
  network_profile_id   = var.network_profile_id
  datasci_db_host      = module.datasci-data.server_fqdn
  datasci_db_password  = module.datasci-data.administrator_password
  datasci_db_ssl_mode  = "require"
  datasci_db_type      = "postgres"
  datasci_db_username  = "${module.datasci-data.administrator_login}@${module.datasci-data.server_fqdn}"
  prometheus_server    = var.prometheus_server
}

module "grafana-integration" {
  source                = "github.com/chesapeaketechnology/grafana-dataintegration.git//terraform?ref=v0.2.8"
  resource_group_name   = var.resource_group_name
  system_name           = var.cluster_name
  location              = var.location
  environment           = var.environment
  default_tags          = var.default_tags
  network_profile_id    = var.network_profile_id
  db_host               = module.datasci-data.server_fqdn
  db_name               = "grafana"
  db_password           = module.datasci-data.administrator_password
  db_user               = "${module.datasci-data.administrator_login}@${module.datasci-data.server_name}"
  consul_server         = var.consul_server
  system_topic_settings = var.system_topic_settings
  topic_settings        = var.topic_settings
}
