variable "location" {
  type        = string
  description = "Región de Azure"
  default     = "eastus"
}

variable "resource_group_name" {
  type        = string
  description = "Nombre del RG"
}

variable "workspace_name" {
  type        = string
  description = "Nombre del Workspace Databricks"
}

variable "pricing_tier" {
  type        = string
  description = "SKU de Databricks (standard, premium, trial, etc.)"
  default     = "premium"
}

variable "tags" {
  type        = map(string)
  default     = {}
}

variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}
