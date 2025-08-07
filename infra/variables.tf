variable "glue_job_name" {
  default = "nyc-yellow-taxi-etl-job"
}

variable "glue_crawler_name" {
  default = "nyc-yellow-taxi-crawler"
}

variable "bucket_name_prefix" {
  default = "first-glue-bkt-grp-three-nyc"
}

# variables.tf

variable "etl_script_s3_key" {
  description = "S3 key (path) where the ETL script will be uploaded"
  type        = string
  default     = "scripts/etl-glue-script.py"
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"  # or your region like "ap-south-1"
}




variable "script_s3_path" {
  default = "s3://first-glue-bkt-grp-three-nyc/scripts/etl-glue-script.py"
}
