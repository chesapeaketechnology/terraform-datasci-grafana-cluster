location       = "usgovarizona"
environment    = "dev"
cluster_name   = "datasci"

subnet_cidr = "10.0.11.0/24"
subnet_start_address = "10.0.11.1"
subnet_end_address = "10.0.11.254"
grafana_admin_user = "admin"

default_tags   = {
  Department  = "Monkey"
  PoC         = "LiveStream"
  System      = "DataSci"
  SubSystem   = "Grafana"
  Role        = "FrontEnd"
  Environment = "DEV"
}