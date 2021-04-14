module "simple" {

  source = "../../"

  name                = "simple"
  resource_group_name = "simple-app-rg"
  location            = "westeurope"

  application_insights = [
    {
      name             = "app1"
      application_type = "web"
      api_keys = [
        {
          name             = "my-api-key"
          read_permissions = ["api", "draft"]
        },
      ]
    },
    {
      name             = "app2"
      application_type = "web"
      api_keys         = [
        {
          name             = "my-api-key2"
          read_permissions = ["api"]
        },
      ]
    },
  ]
}