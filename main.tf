terraform {
  required_version = ">= 0.12.26"
  required_providers {
    azurerm = {
      version = "~> 2.55.0"
    }
  }
}

provider azurerm {
  features {}
}

locals {
  insights_map = { for a in var.application_insights : a.name => a }

  api_keys = flatten([
    for a in var.application_insights : [
      for api_key in a.api_keys : {
        application_insight_name = a.name
        name                     = api_key.name
        read_permissions         = api_key.read_permissions
      }
    ]
  ])
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

resource "azurerm_application_insights" "main" {
  for_each = local.insights_map

  name                = each.key
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = each.value.application_type

  tags = var.tags
}

resource "azurerm_application_insights_api_key" "api_key" {
  for_each = { for api_key in local.api_keys : "${api_key.application_insight_name}-${api_key.name}" => api_key }

  name                    = each.key
  application_insights_id = azurerm_application_insights.main[each.value.application_insight_name].id
  read_permissions        = each.value.read_permissions
  write_permissions       = []

  // Remove when bug https://github.com/terraform-providers/terraform-provider-azurerm/issues/6040 is fixed
  lifecycle {
    ignore_changes = [read_permissions, write_permissions]
  }
}
