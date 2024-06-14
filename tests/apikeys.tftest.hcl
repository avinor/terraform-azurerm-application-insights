variables {
  name                = "apikeys"
  resource_group_name = "apikeys-rg"
  location            = "westeurope"
  workspace_id        = "/subscriptions/12345678-1234-9876-4563-123456789012/resourceGroups/example-resource-group/providers/Microsoft.OperationalInsights/workspaces/workspaceValue"

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
      api_keys = [
        {
          name             = "my2-api-key"
          read_permissions = ["api"]
        },
      ]
    },
  ]
}
run "apikeys" {
  command = plan
}