module "apikeys" {

  source = "../../"

  name                = "webtests"
  resource_group_name = "webtests-rg"
  location            = "westeurope"

  application_insights = [
    {
      name             = "app1"
      application_type = "web"
      api_keys         = []
    },
    {
      name             = "app2"
      application_type = "web"
      api_keys         = []
      web_ping_test = {
        name                      = "my-ping-test"
        url                       = "https://api.company.com/"
        frequency                 = 900
        geo_locations             = ["emea-nl-ams-azr"]
        timeout                   = 120
        expected_http_status_code = 200
      }
    },
  ]
}
