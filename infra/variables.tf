variable "glue_job_name" {
  default = "nyc-yellow-taxi-etl-job"
}

variable "glue_crawler_name" {
  default = "nyc-yellow-taxi-crawler"
}

variable "bucket_name_prefix" {
  default = "first-glue-bkt-grp-three-nyc"
}

variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1" # or your desired region
}



variable "script_s3_path" {
  default = "s3://first-glue-bkt-grp-three-nyc/scripts/etl-glue-script.py"
}
