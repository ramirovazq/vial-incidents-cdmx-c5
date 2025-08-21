resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_databricks_workspace" "this" {
  name                        = var.workspace_name
  resource_group_name         = azurerm_resource_group.this.name
  location                    = azurerm_resource_group.this.location

  sku                         = var.pricing_tier
  managed_resource_group_name = "${var.resource_group_name}-dbx-mrg"

  # Managed VNet (simple). Si no defines custom_parameters.vnet, Databricks crea su red administrada.
  custom_parameters {
    # Si algún día quieres habilitar no-public-ip:
    no_public_ip = true
  }

  tags = var.tags
}
