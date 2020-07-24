location       = "usgovarizona"
environment    = "dev"
cluster_name   = "datasci"

administrator_login = "postgres"
administrator_password = "M0nk3yD@nc3!"

allow_access_from = ["75.57.118.38"]

default_tags   = {
  Department  = "Monkey"
  PoC         = "LiveStream"
  System      = "DataSci"
  SubSystem   = "Grafana"
  Role        = "FrontEnd"
  Environment = "DEV"
}