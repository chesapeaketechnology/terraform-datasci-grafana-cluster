terraform {
  required_version = "~> 0.12"
  experiments      = [variable_validation]
}

provider "azurerm" {
  version = "=> 2.18"
  features {}
  disable_terraform_partner_id = true
}

data "azurerm_resource_group" "gfi_resource_group" {
  name = var.resource_group_name
}


data "azurerm_virtual_network" "gfi_net" {
  name                = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.gfi_resource_group.name
}

# Create subnet for use with containers
resource "azurerm_subnet" "gfi_subnet" {
  name                 = "gfi_integration_subnet"
  resource_group_name  = data.azurerm_resource_group.gfi_resource_group.name
  virtual_network_name = data.azurerm_virtual_network.gfi_net.name
  address_prefixes     = var.subnet_cidrs

  delegation {
    name = "gfi_integration_subnet_delegation"

    service_delegation {
      name = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_network_profile" "gfi_net_profile" {
  name                = join("-", [var.system_name, var.environment, "gfi-net-profile"])
  location            = data.azurerm_resource_group.gfi_resource_group.location
  resource_group_name = data.azurerm_resource_group.gfi_resource_group.name

  container_network_interface {
    name = "container_nic"

    ip_configuration {
      name = "container_ip_config"
      subnet_id = azurerm_subnet.gfi_subnet.id
    }
  }
}

# Create a Container Group
resource "azurerm_container_group" "gfi_container_group" {
  name                = join("-", [var.system_name, var.environment, "grafana-integration"])
  resource_group_name = data.azurerm_resource_group.gfi_resource_group.name
  location            = data.azurerm_resource_group.gfi_resource_group.location
  ip_address_type     = "public"
  dns_name_label      = "grafana-integration"
  os_type             = "Linux"

  tags = var.default_tags

  # Grafana Server
  container {
    name   = "gfi-lte-consumer"
    image  = "chesapeaketechnology/grafana-dataintegration:0.1.0"
    cpu    = "1.0"
    memory = "1.0"

    environment_variables = {
      GDI_TOPIC="lte_message"
      GDI_MESSAGE_TYPE="LteRecord"
      GDI_MESSAGE_VERSION="~=0.1.0"
      GDI_CONSUMER_GROUP="frontend"
      GDI_KEY=var.eventhub_key
      GDI_NAMESPACE=var.eventhub_namespace
      GDI_SHARED_ACCESS_POLICY=var.eventhub_shared_access_policy
      GDI_DB_HOST=var.db_host
      GDI_DB_PORT=var.db_port
      GDI_DB_DATABASE=var.db_name
      GDI_DB_USER=var.db_user
      GDI_DB_PASSWORD=var.db_password
      GDI_DB_SCHEMA=var.db_schema
      GDI_BUFFER_SIZE=var.buffer_size
      LOG_LEVEL=var.log_level

      //      GDI_CHECKPOINT_STORE_CONNECTION=var.
      //      GDI_CHECKPOINT_STORE_CONTAINER=var.
    }
  }
}