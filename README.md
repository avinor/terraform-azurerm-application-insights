# Azure Application Insights

Module to create multiple Application Insights within one resource group.
API keys are supported and is available from the output

## Basic Usage

```terraform
module "simple" {
  source = "github.com/avinor/terraform-azurerm-application-insight?ref=v0.1.0"

  name                = "simple"
  location            = "westeurope"
  resource_group_name = "simple-rg"

  application_insights = [
    {
      name             = "app1"
      application_type = "web"
      api_keys         = [
        {
          name             = "my-api-key"
          read_permissions = ["api", "draft"]
        },
      ]
    },
  ]
}
```

See the example directory for more examples

Output from the module is as follows:

```yaml
api_keys:
  app1-my-key:
    api_key: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
    application_insights_id: /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/my-rg-rg/providers/microsoft.insights/components/app1
    id: /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourcegroups/my-rg/providers/microsoft.insights/components/app1/apikeys/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
ids:
  app1:
    app_id: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
    connection_string: InstrumentationKey=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx;IngestionEndpoint=https://westeurope-3.in.applicationinsights.azure.com/
    id: /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/my-rg/providers/microsoft.insights/components/app1
    instrumentation_key: xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

# Limitations

Changes on API keys are ignored as of
av [bug](https://github.com/terraform-providers/terraform-provider-azurerm/issues/6040) in the azurerm provider.
To change permissions of the api keys new keys has to be created for now.
