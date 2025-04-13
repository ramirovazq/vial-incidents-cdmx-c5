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
  - 3.1.[Alternative A - Local](#31-alternative-a---local)
  - 3.2.[Alternative B - Cloud](#32-alternative-b---cloud)
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
- 8.[Alternative B - Cloud](#8-alternative-b---cloud)
  - 8.1.[Creating service account](#81-creating-service-account)
  - 8.2.[Edit Permissions](#82-edit-permissions)
  - 8.3.[Installing Terraform](#83-installing-terraform)
  - 8.4.[Setting up Terraform files](#84-setting-up-terraform-files)
  - 8.5.[Orchestrating with prefect](#85-orchestrating-with-prefect)
  - 8.6.[Deployment with prefect](#86-deployment-with-prefect)
  - 8.7.[Running Prefect flows on docker containers](#87-running-prefect-flows-on-docker-containers)
  - 8.8.[Dbt](#88-dbt)
  - 8.9.[Looker Studio](#89-looker-studio)
- 9.[Future enhancements ](#9-future-enhancements)
- 10.[References](#10-references)
---

## 1. Description of the problem

<p align="justify">
Mexico City is one of the five most populated urban areas in the world, with approximately 22 million inhabitants. Due to its high population density and a vehicle fleet of around 6.5 million cars (https://www.inegi.org.mx/temas/vehiculos/#tabulados), vial incidents are a phenom that affects residents mobility in a daily manner. 
</p>

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

### 4.0 Data Architecture

<p align="justify">
Architecture with data flow (including orchestrator actions) can be visualized in next image (images\architecture.png). It has been divided in 4 blocks as a way to separte each layer, and could be easier to identify components and tools involved in each state.
</p>

<p align="center">
  <img src="images\architecture.png">
</p>

<p align="justify">
Objective of this project is to be clear in all elements and components involved so as a high level overview take a look on (images\architecture_high_level_overview.png) 
</p>

<p align="center">
  <img src="images\architecture_high_level_overview.png">
</p>

* Data Source
* Collect & Process
* Engine
* Presentation Layer
