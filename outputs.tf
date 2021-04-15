output "ids" {
  description = "The Azure Relay Namespace ID"
  value = {
    for k, v in azurerm_application_insights.main : k => {
      id                  = v.id
      app_id              = v.app_id
      instrumentation_key = v.instrumentation_key
      connection_string   = v.connection_string
    }
  }
  sensitive = true
}

output "api_keys" {
  description = "Map of api keys for the created application insights"
  value = {
    for k, v in azurerm_application_insights_api_key.api_key : k => {
      id                      = v.id
      api_key                 = v.api_key
      application_insights_id = v.application_insights_id
    }
  }
  sensitive = true
}
