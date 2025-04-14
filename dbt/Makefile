# Variables
SERVICE=dbt-bq-dtc

# Probar conexión y configuración de DBT
version:
	docker compose run --rm $(SERVICE) --version

# Probar conexión y configuración de DBT
debug:
	docker compose run --rm $(SERVICE) debug

# Hacer un build (compilación y ejecución)
deps:
	docker compose run --rm $(SERVICE) deps

# Hacer un build (compilación y ejecución)
build:
	docker compose run --rm $(SERVICE) build

prod:
	docker compose run --rm $(SERVICE) build --vars '{'is_test_run': 'false'}'

# Correr todos los modelos
run:
	docker compose run --rm $(SERVICE) run

# Correr solo un modelo específico: make run-model MODEL=model_name
run-model:
	docker compose run --rm $(SERVICE) run --select $(MODEL)

# Testear el proyecto
test:
	docker compose run --rm $(SERVICE) test

# Ver docs (solo genera los archivos; necesitas servirlos tú mismo si quieres verlos)
docs-generate:
	docker compose run --rm $(SERVICE) docs generate

pull-metabase:
	docker pull metabase/metabase:latest

run-metabase:
	docker run -d -p 3000:3000 --name metabase metabase/metabase
