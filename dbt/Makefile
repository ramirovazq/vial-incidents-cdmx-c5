# Variables
SERVICE=dbt-bq-dtc

# Probar conexión y configuración de DBT
debug:
	docker compose run --rm $(SERVICE) debug

# Hacer un build (compilación y ejecución)
deps:
	docker compose run --rm $(SERVICE) deps

# Hacer un build (compilación y ejecución)
build:
	docker compose run --rm $(SERVICE) build

# Entrar a una shell interactiva dentro del contenedor
shell:
	docker compose run --rm $(SERVICE) bash

# Correr todos los modelos
run:
	docker compose run --rm $(SERVICE) dbt run

# Correr solo un modelo específico: make run-model MODEL=model_name
run-model:
	docker compose run --rm $(SERVICE) dbt run --select $(MODEL)

# Testear el proyecto
test:
	docker compose run --rm $(SERVICE) dbt test

# Ver docs (solo genera los archivos; necesitas servirlos tú mismo si quieres verlos)
docs-generate:
	docker compose run --rm $(SERVICE) dbt docs generate

# Limpiar contenedores y volúmenes (si alguna vez lo necesitás)
clean:
	docker compose down -v
