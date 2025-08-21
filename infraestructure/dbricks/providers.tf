terraform {
  required_version = ">= 1.3.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      # Ajusta/pinea versión según tus políticas
    }
    databricks = {
      source = "databricks/databricks"
      # Ajusta/pinea versión según tus políticas
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

# Nota: el provider "databricks" se configura DESPUÉS de crear el workspace, usando su URL/ID (ver databricks.tf).
