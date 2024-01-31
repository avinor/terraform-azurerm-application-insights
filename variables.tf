variable "name" {
  description = "Name of relay hybrid connection, if it contains illegal characters (,-_ etc) those will be truncated."
}

variable "resource_group_name" {
  description = "Name of resource group to deploy resources in."
}

variable "location" {
  description = "Azure location where resources should be deployed."
}

variable "workspace_id" {
  description = "Id of log analytics workspace resource."
}

variable "application_insights" {
  description = "List of application insights"
  type = list(object({
    name             = string
    application_type = string
    api_keys = list(object({
      name             = string
      read_permissions = list(string)
    }))
    web_ping_test = optional(object({
      name                      = string
      url                       = string
      frequency                 = number
      geo_locations             = list(string)
      timeout                   = number
      expected_http_status_code = number
    }))
  }))
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}
