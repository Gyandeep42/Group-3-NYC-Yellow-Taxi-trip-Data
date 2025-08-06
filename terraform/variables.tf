variable "region" {
  default = "us-east-1"
}

variable "raw_bucket_name" {
  default = "opbkt-glue-rawonetwothree"
}

variable "cleaned_bucket_name" {
  default = "gpbkt-cleanedonetwothree"
}

variable "glue_db_name" {
  default = "nyc-yellow-taxi-trip-data-dbonetwothree"
}

variable "glue_job_name" {
  default = "firstjobonetwothree"
}

variable "glue_crawler_name" {
  default = "nyc-crawler-onetwothree"
}

variable "etl_script_s3_key" {
  default = "etl/etl-glue-script.py"
}
