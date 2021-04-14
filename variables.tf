variable "name" {
  description = "Name of relay hybrid connection, if it contains illegal characters (,-_ etc) those will be truncated."
}

variable "resource_group_name" {
  description = "Name of resource group to deploy resources in."
}

variable "location" {
  description = "Azure location where resources should be deployed."
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
  }))
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}
