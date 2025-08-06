# Declare AWS region
variable "region" {
  default = "us-east-1"
}

# Common prefix (used as part of bucket names)
variable "bucket_name_prefix" {
  default = "opbkt-glue-rawautomate"
}

variable "try-ci-cd-bkt-raw" {
  description = "Existing raw S3 bucket name"
  type        = string
}

variable "try-ci-cd-bkt-cleanned" {
  description = "Existing cleaned S3 bucket name"
  type        = string
}

# Glue Catalog Database name
variable "glue_db_name" {
  default = "nyc-yellow-taxi-trip-data-dbauto"
}

# Glue ETL Job name
variable "glue_job_name" {
  default = "firstjobauto"
}

# Glue Crawler name
variable "glue_crawler_name" {
  default = "nyc-crawler-auto"
}

# Path to the ETL script in S3
# (e.g., s3://raw_bucket_name/etl/etl-glue-script.py)
variable "etl_script_s3_key" {
  default = "etl/etl-glue-script.py"
}
