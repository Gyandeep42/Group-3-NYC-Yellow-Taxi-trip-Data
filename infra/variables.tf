# Region
variable "region" {
  default = "us-east-1"
}

# Bucket name prefix (keep fixed so it can be reused)
variable "bucket_name_prefix" {
  default = "third-glue-bkt-grp-three-nyc"
}

# Glue job base name
variable "glue_job_name" {
  default = "glue-etl-job"
}

# Crawler base name
variable "glue_crawler_name" {
  default = "my-etl-crawler"
}

# Script S3 path
variable "script_s3_path" {
  default = "s3://third-glue-bkt-grp-three-nyc/scripts/etl-glue-script.py"
}
variable "glue_role_arn" {
  description = "IAM role ARN to use for Glue Job"
  type        = string
}