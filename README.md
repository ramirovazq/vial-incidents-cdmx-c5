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






# Vial Incidents reported in Mexico City - C5

---
## Index

- 1.[Description of the problem](#1-description-of-the-problem)
- 2.[Objective](#2-objective)
- 3.[Technologies](#3-technologies)
- 4.[Data Architecture](#4-data-architecture)
- 5.[Data description](#5-data-description)
- 6.[Instructions on how to replicate the project](#6-instructions-on-how-to-replicate-the-project)
  - 6.1.[Setting up Google Cloud Platform account](#61-setting-up-google-cloud-platform-account)
  - 6.2.[Creating a VM Instance on Google Compute Engine](#62-creating-a-vm-instance-on-google-compute-engine)
  - 6.3.[VM instance connection configuration](#63-vm-instance-connection-configuration)
  - 6.4.[Setting up VM instance](#64-setting-up-vm-instance)
- 7.[Alternative A - Local](#7-alternative-a---local)
  - 7.1.[Creating a docker-compose](#71-creating-a-docker-compose)
  - 7.2.[Running a docker-compose](#72-running-a-docker-compose)
  - 7.3.[Port Forwarding](#73-port-forwarding)
  - 7.4.[Testing the pipeline](#74-testing-the-pipeline)
  - 7.5.[Orchestrating with prefect](#75-orchestrating-with-prefect)
- 8.[References](#8-references)
---

## 1. Description of the problem


Mexico City is one of the five most populated urban areas in the world, with approximately 22 million inhabitants. Due to its high population density and a vehicle fleet of around 6.5 million cars [reference 1](#81-reference), vial incidents are a phenom that affects residents mobility in a daily manner. 


<p align="justify">
For this reason Mexico's government created the "Command, Control, Computing, Communications and Citizen Contact Center of Mexico City" (well known as C5) in order to find a way to monitor and improve emergencies and vial incidents. C5 is also responsible for collecting comprehensive data for public safety, medical emergencies, environment, civil protection and mobility. 
</p>

<p align="justify">
As a way to understand vial incidents phenom it's possible to get historical data from Mexico's data website https://datos.cdmx.gob.mx and then generate visuals that could help identifying patterns like: days/hours with major incidence, top neighbors with more incidents (among others). Finding patterns could raise specific actions over neighbors/days/hours.
</p>

## 2. Objective

<p align="justify">
Develop a data architecture capable of ingesting historical data on traffic incidents in Mexico City, starting from 2014 (https://datos.cdmx.gob.mx/dataset/incidentes-viales-c5) up to the most recent available records. This architecture should support data ingestion, processing, and analysis. The final product should be a visual dashboard highlighting the days and hours with the highest incidence, the top neighborhoods with the most reported incidents, and offer interactive insights into categories and frequency patterns within the data.
</p>

## 3. Technologies

For setting this project it's necessary to count with:

- Docker and Docker-Compose
- A GCP account
- DBT (we could use DBT Cloud account or local DBT with Docker)
- Kestra (as orchestrator)
- Metabase or Looker Studio (as visualizator tool)

## 4. Data Architecture


The architecture and data flow (including orchestrator actions) are shown in the image below (images/architecture.png).
It is divided into four blocks, each representing a different layer, making it easier to identify the components and tools involved at each stage.
This flow is designed for ***batch processing***, as data updates in the files occur yearly.
It's important to note that this architecture follows an ***ELT*** approach, since the raw data is stored first and then processed and transformed in later steps.


<p align="center">
  <img src="images\architecture.png">
</p>


One of the main objectives of this project is to keep all elements as clear as possible, so please refer to the following high-level overview diagram (images/architecture_high_level_overview_.png).


<p align="center">
  <img src="images\architecture_high_level_overview_diagram.png">
</p>

* **Data Source**: In this case, it refers to the website where the original data (CSV files) is obtained: https://datos.cdmx.gob.mx/dataset/incidentes-viales-c5  
* **Collect & Process**: The data will be uploaded to our ***Data Lake*** (an S3-compatible bucket in GCS). Then, we will create an external table in BigQuery using the CSV files from the bucket as the source. The next step is to transform the data by applying ***Analytics Engineering*** with DBT. All table metadata will be stored in BigQuery.  
* **Engine**: The tables generated by DBT will be available for consumption via BigQuery. This acts as our ***Data Warehouse***. It's important to notice that partition, clustering and data modeling is being considered in this layer. 
* **Presentation Layer**: Finally, we can connect different visualization tools in this layer. In our case, we are considering **Metabase**.


## 5. Data Description


## 8. References

- Reference 1 [#81-reference] https://www.inegi.org.mx/temas/vehiculos/#tabulados