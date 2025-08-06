variable "region" {
  default = "us-east-1"
}

variable "raw_bucket_name" {
  default = "opbkt-glue-rawone"
}

variable "cleaned_bucket_name" {
  default = "gpbkt-cleanedone"
}

variable "glue_db_name" {
  default = "nyc-yellow-taxi-trip-data-dbone"
}

variable "glue_job_name" {
  default = "firstjobonetwo"
}

variable "glue_crawler_name" {
  default = "nyc-crawler-onetwo"
}

variable "etl_script_s3_key" {
  default = "etl/etl-glue-script.py"
}
