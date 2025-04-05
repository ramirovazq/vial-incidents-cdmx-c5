# vial-incidents-cdmx-c5
This repository aims to show a dashboard of vial incidents in CDMX


## Steps to generate infrastructure
```
$ cd infraestructure/
$ terraform init
$ terraform plan
$ terraform apply
```

## Steps to upload data to our lake in GCP
### 1st lets start Kestra using docker
```
$ docker run --pull=always --rm -it -p 8080:8080 --user=root -v /var/run/docker.sock:/var/run/docker.sock -v /tmp:/tmp kestra/kestra:latest server local
```

### Add 3 flows to Kestra and run via Ui
- 01_gcp_kv
- 02_gcp_create_bucket_and_dataset
- 03_upload_and_create_external

## Run DBT using docker
```
$ cd dbt
$ make version
$ make debug
$ make deps
$ make build
$ make prod
```