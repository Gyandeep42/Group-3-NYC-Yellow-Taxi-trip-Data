variable "region" {
  default = "us-east-1"
}

variable "raw_bucket_name" {
  default = "opbkt-glue-raw"
}

variable "cleaned_bucket_name" {
  default = "gpbkt-cleaned"
}

variable "glue_db_name" {
  default = "nyc-yellow-taxi-trip-data-db"
}

variable "glue_job_name" {
  default = "firstjobone"
}

variable "glue_crawler_name" {
  default = "nyc-crawler-one"
}

variable "etl_script_s3_key" {
  default = "etl/etl-glue-script.py"
}
