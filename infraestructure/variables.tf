variable "project" {
  description = "Project"
  default     = "vialincidentsc5"
}


variable "location" {
  description = "Project location"
  default     = "US"
}

variable "region" {
  description = "Region"
  default     = "us-central1"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  default     = "vial_incidents_13042025"
}

variable "gcs_bucket_name" {
  description = "My Data Lake for vial incidents files dezoomcamp final project"
  default     = "vial_incidents_13042025"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDAR"
}