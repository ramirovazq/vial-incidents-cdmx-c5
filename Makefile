# Makefile

run-kestra:
	docker run --pull=always --rm -it \
		-p 8080:8080 \
		--user=root \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v /tmp:/tmp \
		kestra/kestra:latest server local

post-gcp-kv-flow:
	curl -X POST http://localhost:8080/api/v1/flows -H "Content-Type: application/x-yaml" --data-binary @orchestrator/kestra/01_gcp_kv

execute-gcp-kv-flow:
	$ curl -X POST http://localhost:8080/api/v1/executions/vial_incidents_project/01_gcp_kv

post-gcp-create-flow:
	curl -X POST http://localhost:8080/api/v1/flows -H "Content-Type: application/x-yaml" --data-binary @orchestrator/kestra/02_gcp_create_bucket_and_dataset

execute-gcp-create-flow:
	$ curl -X POST http://localhost:8080/api/v1/executions/vial_incidents_project/02_gcp_create_bucket_and_dataset

post-upload-and-create-external-flow:
	curl -X POST http://localhost:8080/api/v1/flows -H "Content-Type: application/x-yaml" --data-binary @orchestrator/kestra/03_upload_and_create_external

post-upload-2014-2015
	$ curl -v -X POST -H 'Content-Type: multipart/form-data' -F 'year_range=2014_2015' 'http://localhost:8080/api/v1/executions/vial_incidents_project/03_upload_and_create_external'

post-upload-2016-2018
	curl -v -X POST -H 'Content-Type: multipart/form-data' -F 'year_range=2016_2018' 'http://localhost:8080/api/v1/executions/vial_incidents_project/03_upload_and_create_external'

post-upload-2019-2021
	curl -v -X POST -H 'Content-Type: multipart/form-data' -F 'year_range=2019_2021' 'http://localhost:8080/api/v1/executions/vial_incidents_project/03_upload_and_create_external'

post-upload-2022-2024
	curl -v -X POST -H 'Content-Type: multipart/form-data' -F 'year_range=2022_2024' 'http://localhost:8080/api/v1/executions/vial_incidents_project/03_upload_and_create_external'