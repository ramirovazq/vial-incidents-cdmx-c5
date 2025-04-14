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

execute-gcp-kv-flow:
	$ curl -X POST http://localhost:8080/api/v1/executions/vial_incidents_project/02_gcp_create_bucket_and_dataset
