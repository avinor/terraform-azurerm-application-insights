terraform {
  required_version = ">= 1.3"
  required_providers {
    azurerm = {
      version = "~> 3.107.0"
    }
    random = {
      version = "~> 3.6.2"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  insights_map = { for a in var.application_insights : a.name => a }

  web_tests_map = { for a in var.application_insights : a.name => a.web_ping_test if a.web_ping_test != null }

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

  name                = "${each.key}-appi"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  workspace_id        = var.workspace_id
  application_type    = each.value.application_type

  tags = var.tags
}

resource "random_uuid" "test_id" {
  for_each = local.web_tests_map
}

resource "random_uuid" "request_id" {
  for_each = local.web_tests_map
}

resource "azurerm_application_insights_web_test" "ping_test" {
  for_each = local.web_tests_map

  name                    = "${each.value.name}-wt"
  kind                    = "ping"
  enabled                 = true
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  application_insights_id = azurerm_application_insights.main[each.key].id
  frequency               = each.value.frequency
  timeout                 = each.value.timeout
  geo_locations           = each.value.geo_locations // See: https://learn.microsoft.com/en-us/azure/azure-monitor/app/monitor-web-app-availability#location-population-tags
  tags                    = var.tags
  configuration           = <<XML
<WebTest
        Name="${each.value.name}-wt" Id="${random_uuid.test_id[each.key].result}" Enabled="True" CssProjectStructure="" CssIteration=""
        Timeout="${each.value.timeout}" WorkItemIds="" xmlns="http://microsoft.com/schemas/VisualStudio/TeamTest/2010" Description=""
        CredentialUserName="" CredentialPassword="" PreAuthenticate="True" Proxy="default" StopOnError="False"
        RecordedResultFile="" ResultsLocale="">
    <Items>
        <Request Method="GET" Guid="${random_uuid.request_id[each.key].result}" Version="1.1"
                 Url="${each.value.url}" ThinkTime="0" Timeout="${each.value.timeout}"
                 ParseDependentRequests="True" FollowRedirects="True" RecordResult="True" Cache="False"
                 ResponseTimeGoal="0"
                 Encoding="utf-8" ExpectedHttpStatusCode="${each.value.expected_http_status_code}" ExpectedResponseUrl="" ReportingName=""
                 IgnoreHttpStatusCode="False"/>
    </Items>
</WebTest>
XML
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
