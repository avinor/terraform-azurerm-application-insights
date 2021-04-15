module "simple" {

  source = "../../"

  name                = "simple"
  resource_group_name = "simple-app-rg"
  location            = "westeurope"

  application_insights = [
    {
      name             = "app1"
      application_type = "web"
      api_keys = []
     },
    {
      name             = "app2"
      application_type = "web"
      api_keys         = []
    },
  ]
}