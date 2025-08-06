variable "region" {
  default = "us-east-1"
}

variable "raw_bucket_name" {
  default = "opbkt-glue-rawonetwothreefour"
}

variable "cleaned_bucket_name" {
  default = "gpbkt-cleanedonetwothreefour"
}

variable "glue_db_name" {
  default = "nyc-yellow-taxi-trip-data-dbonetwothreefour"
}

variable "glue_job_name" {
  default = "firstjobonetwothreefour"
}

variable "glue_crawler_name" {
  default = "nyc-crawler-onetwothreefour"
}

variable "etl_script_s3_key" {
  default = "etl/etl-glue-script.py"
}
