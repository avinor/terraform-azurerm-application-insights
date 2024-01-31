module "simple" {

  source = "../../"

  name                = "simple"
  resource_group_name = "simple-app-rg"
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
    },
  ]
}