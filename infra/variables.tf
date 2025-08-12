# AWS region
variable "region" {
  default = "us-east-1"
}

# Hardcoded S3 bucket name for storing Glue script
variable "etl_bucket_name" {
  default = "third-glue-bkt-grp-three-nyc"
}


# IAM Role ARN for Glue job & crawler
variable "glue_role_arn" {
  default = "arn:aws:iam::963702399712:role/LabRole"
}

# Script S3 path (latest version will be handled by GitHub Actions)
variable "script_s3_path" {
  default = "s3://third-glue-bkt-grp-three-nyc/scripts/latest/etl-glue-script.py"
}

# Raw data location for Glue Crawler
variable "raw_data_s3_path" {
  default = "s3://raw-data-grp-3/cleaned-data/transformeddata/"
}
