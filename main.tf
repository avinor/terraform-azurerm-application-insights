terraform {
  required_version = ">= 0.12.6"
  required_providers {
    azurerm = {
      version = "~> 2.53.0"
    }
  }
}

provider azurerm {
  features {}
}

locals {
  insights_map = { for a in var.application_insights : a.name => a }
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