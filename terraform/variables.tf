# Declare AWS region
variable "region" {
  default = "us-east-1"
}

# Common prefix (used as part of bucket names)
variable "bucket_name_prefix" {
  default = "opbkt-glue-rawautomate"
}

# Raw S3 bucket name
variable "raw_bucket_name" {
  default = "try-ci-cd-bkt-raw"
}

# Cleaned S3 bucket name
variable "cleaned_bucket_name" {
  default = "try-ci-cd-bkt-cleanned"
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
