module "apikeys" {

  source = "../../"

  name                = "apikeys"
  resource_group_name = "apikeys-rg"
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
          name             = "my2-api-key"
          read_permissions = ["api"]
        },
      ]
    },
  ]
}