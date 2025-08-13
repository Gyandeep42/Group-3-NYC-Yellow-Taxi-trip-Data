#declare a region
variable "region" {
  default = "us-east-1"
}

#declare a bucket name
variable "bucket_name_prefix" {
  default = "third-glue-bkt-grp-three-nyc"
}


#declare a glue job name
variable "glue_job_name" {
  default = "glue-etl-job"
}

#declare a crawler name
variable "glue_crawler_name" {
  default = "my-etl-crawler"
}

# Get the bucket name that matches the prefix
data "aws_s3_bucket" "script_bucket" {
  bucket = "${var.bucket_name_prefix}-pnv21f" # Or dynamically fetched
}

# Build the script path dynamically from actual bucket
locals {
  script_s3_path = "s3://${aws_s3_bucket.etl_bucket.bucket}/scripts/etl-glue-script.py"
}