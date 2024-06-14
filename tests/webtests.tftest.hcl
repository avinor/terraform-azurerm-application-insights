variables {
  name                = "webtests"
  resource_group_name = "webtests-rg"
  location            = "westeurope"
  workspace_id        = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.OperationalInsights/workspaces/workspaceValue"

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
run "webtests" {
  command = plan
}