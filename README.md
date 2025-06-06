# vial-incidents-cdmx-c5
This repository aims to show a dashboard of vial incidents in CDMX

# Vial Incidents reported in Mexico City - C5

---
## Index

- 1.[Description of the problem](#1-description-of-the-problem)
- 2.[Objective](#2-objective)
- 3.[Technologies](#3-technologies)
- 4.[Data Architecture](#4-data-architecture)
- 5.[Data description](#5-data-description)
- 6.[Instructions on how to replicate the project](#6-instructions-on-how-to-replicate-the-project)
- 6.1. [Setting up Google Cloud Platform account](#61-setting-up-google-cloud-platform-account)
  - [6.1.1. Visit the Google Cloud official website](#611-visit-the-google-cloud-official-website)
  - [6.1.2. Click on "Get started for free"](#612-click-on-get-started-for-free)
  - [6.1.3. Sign in with your Google account](#613-sign-in-with-your-google-account)
  - [6.1.4. Fill in your personal and billing information](#614-fill-in-your-personal-and-billing-information)
  - [6.1.5. Accept the terms and conditions](#615-accept-the-terms-and-conditions)
  - [6.1.6. Done! Your GCP account is now ready](#616-done-your-gcp-account-is-now-ready-)
  - [6.1.7. Open GCP Console](#617-open-gcp-console)
  - [6.1.8. Create service account](#618-create-serive-account)
- 7.[7. Run the project](#7-run-the-project)
  - [7.1 Necessary to run Kestra (orchestrator) with docker](#71-necessary-to-run-kestra-orchestrator-with-docker)
  - [7.2 Necessary to add next 2 flows in Kestra](#72-necessary-to-add-next-2-flows-in-kestra)
  - [7.3 Add flow for upload data to bucket](#73-add-flow-for-upload-data-to-bucket)
  - [7.4 Run DBT in docker and docker-compose](#74-run-dbt-in-docker-and-docker-compose)
  - [7.5 Validate tables generated in BigQuery](#75-validate-tables-generated-in-bigquery)
  - [7.6 Run Metabase as visualizator](#76-run-metabase-as-visualizator)
- 8.[References](#8-references)
  - [8.1 Reference 1](#81-reference-1)
  - [8.1 Reference 2](#82-reference-2)


---
Preferable tu use docker with dbt section 7.4 to reproduce in a quick way

- 6.2. [Setting up DBT Cloud account](#62-setting-up-dbt-cloud-account)
  - [6.2.1. Go to the DBT Cloud website](#621-go-to-the-dbt-cloud-website)
  - [6.2.2. Go to the DBT Cloud website](#622--signup-in-dbt-cloud-website-and-verify-your-new-account)
  - [6.2.3. Choose your signup method](#623-choose-your-signup-method)
  - [6.2.4. Complete your account setup](#624-complete-your-account-setup)
  - [6.2.5. Connect a data warehouse](#625-connect-a-data-warehouse)
  - [6.2.6. Connect a Git repository](#626-connect-a-git-repository)


---

## 1. Description of the problem


Mexico City is one of the five most populated urban areas in the world, with approximately 22 million inhabitants. Due to its high population density and a vehicle fleet of around 6.5 million cars [reference 1](#81-reference-1), vial incidents are a phenom that affects residents mobility in a daily manner. 


<p align="justify">
For this reason Mexico's government created the "Command, Control, Computing, Communications and Citizen Contact Center of Mexico City" (well known as C5 [reference 2](#81-reference-2)) in order to find a way to monitor and improve emergencies and vial incidents. C5 is also responsible for collecting comprehensive data for public safety, medical emergencies, environment, civil protection and mobility. 
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

- Git installed
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

For this data anlysis we are considering all historicial data available of vial incidents in Mexico City [data-original-source-vial-incidents-c5](https://datos.cdmx.gob.mx/dataset/incidentes-viales-c5). Range of data (considered as raw data) in years:

- 2022-2024
- 2019-2021
- 2016-2018
- 2014-2015

There is a dictionary of columns in spanish [data-dictionary-spanish](https://datos.cdmx.gob.mx/dataset/a6d1d483-65d2-4ed9-9687-1932eb0cf70f/resource/49b5360c-5922-46bd-b4f8-ed0225d5ddbf/download/diccionario-incidentes-viales-c5.xlsx). Next is the table for english people:

| **Column**               | **Description**                                                                                                                                      |
|--------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| **Folio**                | Unique alphanumeric code assigned to each reported incident (in C5 and C2 centers). It includes the center initials, date (YY/MM/DD), and a sequence number. Example: AO/181201/10801 |
| **Creation Date**        | Date the event record (folio) was created                                                                                                            |
| **Creation Time**        | Time the event record (folio) was created                                                                                                            |
| **Day of the Week**      | Day when the event record was created                                                                                                                |
| **Closing Date**         | Date when the event record was closed                                                                                                                |
| **Closing Time**         | Time when the event record was closed                                                                                                                |
| **Incident Type**        | General type of incident                                                                                                                             |
| **Incident**             | Specific incident reported                                                                                                                           |
| **Initial Municipality** | Municipality where the incident was initially reported                                                                                               |
| **Latitude**             | Latitude                                                                                                                                              |
| **Longitude**            | Longitude                                                                                                                                             |
| **Closing Code**         | Code assigned to the incident at the time of closure                                                                                                 |
| **Classification**       | Classification or category of the incident                                                                                                           |
| **Reporting Channel**    | Channel through which the incident was reported (e.g., phone, app)                                                                                   |
| **Closing Municipality** | Municipality where the incident record was closed                                                                                                    |


## 6 Instructions on how to replicate the project

This project aims to be as reproducible as possible, while remaining as agnostic as possible to your preferred operating system. It will use tools like Docker and Docker Compose.
Additionally, you’ll need a Google Cloud Platform (GCP) account and a DBT Cloud account (although an alternative using DBT with Docker will also be provided).
This first section focuses on how to set up both GCP and DBT cloud account.

## 6.1 Setting up Google Cloud Platform account

Follow these steps to create your GCP account and access cloud services with free credits.
Objective of these steps:
- Create a GCP account
- Generate a service account, and a json key file.

### 6.1.1 Visit the Google Cloud official website
Go to: [https://cloud.google.com/](https://cloud.google.com/)

### 6.1.2 Click on "Get started for free"
This will redirect you to a sign-up form where you can claim free credits (typically **$300 USD for 90 days**).

<p align="center">
  <img src="images\free_credits.png">
</p>


### 6.1.3 Sign in with your Google account
- If you already have a Gmail account, use it to sign in.
- If not, you can create one here: [https://accounts.google.com/signup](https://accounts.google.com/signup)

### 6.1.4 Fill in your personal and billing information
Google will ask for:
- Full name
- Country
- A valid credit or debit card (⚠️ **you won’t be charged** unless you manually upgrade after using the free credits)

This step is just to verify your identity and prevent abuse of the free tier.

### 6.1.5 Accept the terms and conditions
Review and accept the usage terms, then click **"Start my free trial"**.

### 6.1.6 Done! Your GCP account is now ready 🎉
You can now access the GCP Console here:  
[https://console.cloud.google.com/](https://console.cloud.google.com/)

### 6.1.7 Open GCP console

Open console in GCP [https://console.cloud.google.com/](https://console.cloud.google.com/) and create a new project: "vialincidentsc5"

<p align="center">
  <img src="images\create_project_vialincidentsc5.png">
</p>

### 6.1.8 Create serive account

Select GCP IAM > create service account

<p align="center">
  <img src="images\iam_service_account.png">
</p>

<p align="center">
  <img src="images\create_service_account.png">
</p>

Add details for this new service account
<p align="center">
  <img src="images\data_service_acccount.png">
</p>

Add cloud storage > Storage admin role
<p align="center">
  <img src="images\cloud_storage_admin.png">
</p>

Add Big Query > Big Query admin role
<p align="center">
  <img src="images\big_query_admin.png">
</p>

<p align="center">
  <img src="images\done_servie_account.png">
</p>

Click in recently created service account
<p align="center">
  <img src="images\select_recently_created_service_account.png">
</p>
<p align="center">
  <img src="images\search_for_keys_tab_in_new_service_account.png">
</p>

Click in add new key
<p align="center">
  <img src="images\add_new_key.png">
</p>

Add new key as json
<p align="center">
  <img src="images\add_new_key_json.png">
</p>

Add new key as json
<p align="center">
  <img src="images\download_recently_created_key_json.png">
</p>


## 7. Run the project 

With these 2 steps configured (DBT cloud account and GCP account), next step will consist of run project. 

So zero step is to clone the repository to your local machine, run the following command in your terminal:

```bash
git clone https://github.com/ramirovazq/vial-incidents-cdmx-c5.git
```

Then, navigate into the project directory:
```
cd vial-incidents-cdmx-c5
```


### 7.1 Necessary to run Kestra (orchestrator) with docker

As first step use make file with next command:

```
$ make run-kestra
```

What this command does behind, is to run Kestra using docker:
```
$ docker run --pull=always --rm -it -p 8080:8080 --user=root -v /var/run/docker.sock:/var/run/docker.sock -v /tmp:/tmp kestra/kestra:latest server local
```

When in terminal appears something like next image means kestra is running:

<p align="center">
  <img src="images\kestra_running.png">
</p>

Now open a browser and visit 
```
 http://localhost:8080
 ```
You should see something similar:
 <p align="center">
  <img src="images\kestra_welcome.png">
</p>

Now with Kestra we will create necessary infraestructure:
- BigQuery dataset
- Google cloud storage that will storage CSV files from source

### 7.2 Necessary to add next 2 flows in Kestra

- 01_gcp_kv: this ones are necessary to connect with BigQuery
- 02_gcp_create_bucket_and_dataset : will create bucket and dataset in BigQuery

In a new terminal run next command to add flow **01_gcp_kv** to your kestra running in local

```
$ make post-gcp-kv-flow
```
then you should execute
```
$ make execute-gcp-kv-flow
```


Now add your json file to kestra, so click in namespaces and select vial_incidents_project:
<p align="center">
  <img src="images\namespaces_in_kestra.png">
</p>


<p align="center">
  <img src="images\kestra_click_in_kv_store.png">
</p>

Then edit GCP_CREDS

<p align="center">
  <img src="images\edit_gcp_creds.png">
</p>

Will be necesary to substitute content of field with content of json file
<p align="center">
  <img src="images\replace_this_text_with_content_of_json_file.png">
</p>

<p align="center">
  <img src="images\replace_content.png">
</p>


```
$ make post-gcp-create-flow
```
then you should execute new flow
```
$ make execute-gcp-create-flow
```

### 7.3 Add flow for upload data to bucket

Now we need to create new flow that will be in charge of upload data to GCP bucket and also of create table as external in gcp
```
$ make post-upload-and-create-external-flow
```

then you should execute new flows for upload data. Take in count that this could take time to upload to GCS bucket
```
$ make post-upload-2014-2015
$ make post-upload-2016-2018
$ make post-upload-2019-2021
$ make post-upload-2022-2024
```

### 7.4 Run DBT in docker and docker-compose

Now we will run dbt using docker, so first step is to change directory to dbt

```
$ cd dbt
```

- Create `profiles.yml` file in `~/.dbt/` in your local machine or add the following code in your existing `profiles.yml`

```yaml
bq-dbt-workshop:
  outputs:
    dev:
      dataset: vial_incidents_13042025
      fixed_retries: 1
      keyfile: /secrets/google_credentials.json
      location: us-central1
      method: service-account
      priority: interactive
      project: vialincidentsc5
      threads: 4
      timeout_seconds: 300
      type: bigquery
  target: dev
```

- Create `google_credentials.json` file in `~/.google/credentials/google_credentials.json` in your local machine with the content of gcp json file has being used for authentication

```
$ docker compose build 
```

Now run to verify

```
$ make version
$ make debug
```

If everything is fine, then install dependencies:
```
$ make deps
```

Do a build of the project:
```
$ make build
```

Do a deploy of the project:
```
$ make prod
```

<p align="center">
  <img src="images\output_final_dbt_deploy_production.png">
</p>

### 7.5 Validate tables generated in BigQuery 

Now go to your GCP > BigQuery account and validate all tables generated as 'dim_' and 'fact_table'. As you can see ***fact_table*** is partitioned by year. In fact for the size of files wouldn't be necessary, but it was additioned for learning purposes.

<p align="center">
  <img src="images\fact_table_partitioned.png">
</p>

It was created following next code:
```
{{ config(
    materialized='table',
    partition_by={
        "field": "year_creation_date",
        "data_type": "INT64",
        "range": {
            "start": 2014,
            "end": 2024,
            "interval": 1
        }
    },
    cluster_by=["month_creation_date", "hour_creation_date","index_incident"]) 
}}
```

### 7.6 Run Metabase as visualizator

Now let's pull metabase using docker
```
$ make pull-metabase
```

Now run metabase using docker
```
$ make run-metabase
```

Visit next url, where you should wait for some minutes while metabase is being installed

http://localhost:3000/


<p align="center">
  <img src="images\metabase_being_installed.png">
</p>

Wait and click in start like in next image

<p align="center">
  <img src="images\click_in_start_metabase.png">
</p>

Next step is to select language, and follow screens with your data:
- name
- last name
- email
- company, could be 'personal'
- password (don't forget to write in a safe plase, and don't forget it)

<p align="center">
  <img src="images\select_big_query.png">
</p>

Now you should select a name to show, in my case 'MyBigquery', then select your json file (the one was downloaded from GCP) we'be been using all this setup
<p align="center">
  <img src="images\configure_metabase_name_to_show.png">
</p>

Finally lets add 2 tiles to metabase

First click in new > SQL
<p align="center">
  <img src="images\metabase_click_new.png">
</p>

paste there next code and save as 'list_of_incidents' as an example:

```
SELECT
  `vial_incidents_13042025.dim_incident`.`index_incident` AS `index_incident`,
  `vial_incidents_13042025.dim_incident`.`incident` AS `incident`
FROM
  `vial_incidents_13042025.dim_incident`
ORDER BY
  `vial_incidents_13042025.dim_incident`.`incident` ASC
LIMIT
  1048575
```

<p align="center">
  <img src="images\list_of_incidents.png">
</p>


As an example of 2 tiles

<p align="center">
  <img src="images\example_dashboard_2_tiles.png">
</p>

It's recomendable to use table that start with 'Report' cause are aggregated queries 

<p align="center">
  <img src="images\metabase_reports.png">
</p>

As example of questions:

<p align="center">
  <img src="images\question_1_example.png">
</p>

<p align="center">
  <img src="images\question_2_example.png">
</p>

 
## 8. References

### 8.1 Reference 1
- https://www.inegi.org.mx/temas/vehiculos/#tabulados

### 8.2 Reference 2
- https://www.c5.cdmx.gob.mx/dependencia/acerca-de



## Steps to generate infrastructure using terraform as alternative way to test infra as code
```
$ cd infraestructure/
$ export GOOGLE_CREDENTIALS='/Users/file.json'
$ terraform init
$ terraform plan
$ terraform apply
```

## This section for DBT I don't encorage you tu use this projec
Reason is that when testing if don't save the key in github repository, was difficult to connect to dbt cloud. But feel free to consider it if you can bypass this step of sharing key generated by dbt, in github repository.

## 6.2 Setting up DBT cloud account

Follow these steps to create your DBT cloud account. I wrote this thinking in that would be easy to reproduce in cloud, but I found that it's easier (I mean more reproducable) using dbt with docker in your local, so please refer to 7.4 Run DBT in docker and docker-compose

### 6.2.1 Go to the DBT Cloud website
Visit: [https://www.getdbt.com/](https://www.getdbt.com/)

Follow the steps below to create a free DBT Cloud account and start building data transformation workflows.

### 6.2.2  Signup in DBT Cloud website and verify your new account

Or go directly to the signup page:  
👉 [https://cloud.getdbt.com/signup/](https://cloud.getdbt.com/signup/)

At the end, you should verify new account:

<p align="center">
  <img src="images\verify_db_new_account.png">
</p>

### 6.2.3 Choose your signup method

You can sign up using:
- **Email and password**, or
- A **GitHub** or **Google** account (recommended for easy integration)

### 6.2.4 Complete your account setup

- Enter your name and company information (if asked)
- Choose a **free plan** (Starter Plan)
- Set your **workspace name**

### 6.2.5 Connect a data warehouse

Choose default project name in DBT

<p align="center">
  <img src="images\choose_default_project_name.png">
</p>

Now you will need to upload your json file that was create in 6.1.8 step

<p align="center">
  <img src="images\dbt_upload_json_account_from_step_1.png">
</p>


<p align="center">
  <img src="images\dbt_upload_json_account_from_step_2.png">
</p>


After creating your account, DBT Cloud will prompt you to connect to a data warehouse 

<p align="center">
  <img src="images\dbt_do_a_connection.png">
</p>

<p align="center">
  <img src="images\dbt_select_bigquery_connection.png">
</p>

Select Connection with BigQuery and put in dataset: vial_incidents

<p align="center">
  <img src="images\dbt_configure_connection.png">
</p>


You’ll need credentials or a service account from your cloud provider (e.g., GCP for BigQuery).

### 6.2.6 Connect a Git repository

DBT Cloud uses Git to version control your DBT project. In our case use "git clone" with this parameter ```git@github.com:ramirovazq/vial-incidents-cdmx-c5.git```

<p align="center">
  <img src="images\dbt_git_clone.png">
</p>

<p align="center">
  <img src="images\git_clone_with_import.png">
</p>

<p align="center">
  <img src="images\dbt_project_ready.png">
</p>

Now in dashboard click in settings

<p align="center">
  <img src="images\dbt_dashboard_settings.png">
</p>

<p align="center">
  <img src="images\dbt_click_in_settings.png">
</p>

Configure project subdirectory: analytics_engineering
It's possible to add free description and finally click in Save button

<p align="center">
  <img src="images\dbt_parameters_update.png">
</p>
