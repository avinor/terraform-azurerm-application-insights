output "ids" {
  description = "The Azure Relay Namespace ID"
  value = {
    for k, v in azurerm_application_insights.main : k => {
      id                  = v.id
      instrumentation_key = v.instrumentation_key
      app_id              = v.app_id
      connection_string   = v.connection_string
    }
  }
  sensitive = true
}
