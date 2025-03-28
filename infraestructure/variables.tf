variable "project" {
  description = "Project"
  default     = "utility-cathode-448702-g7"
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
  default     = "vial_incidents"
}

variable "gcs_bucket_name" {
  description = "My Data Lake for vial incidents files dezoomcamp final project"
  default     = "vial_incidents"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDAR"
}