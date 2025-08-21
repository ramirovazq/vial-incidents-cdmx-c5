# Configura el provider con el workspace creado
provider "databricks" {
  host                       = azurerm_databricks_workspace.this.workspace_url
  azure_workspace_resource_id = azurerm_databricks_workspace.this.id
}

# Ejemplo: un Secret Scope respaldado por Key Vault (opcional)
# Primero necesitarías un Key Vault y darle permisos a la Managed Identity de Databricks Workspace.

# Ejemplo: crear un cluster de prueba
resource "databricks_cluster" "dev" {
  cluster_name            = "dev-cluster"
  spark_version           = "13.3.x-scala2.12" # ajusta a una versión disponible en tu región
  node_type_id            = "Standard_DS3_v2"  # ajusta a tu preferido/permitido
  autotermination_minutes = 10
  num_workers             = 2

  # (Opcional) si usas UC y/o políticas de clusters, podemos referenciarlas aquí.
}

# Ejemplo: un job sencillo (si tienes un notebook existente)
# resource "databricks_job" "notebook_job" {
#   name = "hello-job"
#   task {
#     task_key = "run-notebook"
#     notebook_task {
#       notebook_path = "/Shared/hello"
#     }
#   }
# }
