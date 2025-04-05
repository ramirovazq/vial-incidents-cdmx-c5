# Variables
TF_BIN=terraform
TF_DIR=infraestructure/
TF_VAR_FILE=infraestructure/variables.tf

# Inicializar Terraform
init:
	$(TF_BIN) -chdir=$(TF_DIR) init 

# Validar la configuración de Terraform
validate:
	$(TF_BIN) validate $(TF_DIR)

# Crear el plan de ejecución de Terraform
plan:
	$(TF_BIN) -var-file=$(TF_VAR_FILE)  plan 

# Aplicar los cambios definidos en el plan
apply:
	$(TF_BIN) apply -var-file=$(TF_VAR_FILE) -auto-approve $(TF_DIR)

# Destruir los recursos de Terraform
destroy:
	$(TF_BIN) destroy -var-file=$(TF_VAR_FILE) -auto-approve $(TF_DIR)

# Mostrar el estado actual de los recursos
show:
	$(TF_BIN) show tfplan

# Obtener las dependencias y módulos de Terraform
get:
	$(TF_BIN) get $(TF_DIR)

# Formatear archivos de configuración de Terraform
fmt:
	$(TF_BIN) fmt $(TF_DIR)

# Limpiar el estado y recursos no utilizados
clean:
	rm -rf terraform_files/.terraform
	rm -rf terraform_files/terraform.tfstate
	rm -rf terraform_files/terraform.tfstate.d
