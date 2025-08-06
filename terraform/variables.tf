# Declare AWS region
variable "region" {
  default = "us-east-1"
}

# Common prefix (used as part of bucket names)
variable "bucket_name_prefix" {
  default = "opbkt-glue-rawonetwothreefour"
}

# Raw S3 bucket name
variable "raw_bucket_name" {
  default = "opbkt-glue-rawonetwothreefour"
}

# Cleaned S3 bucket name
variable "cleaned_bucket_name" {
  default = "gpbkt-cleanedonetwothreefour"
}

# Glue Catalog Database name
variable "glue_db_name" {
  default = "nyc-yellow-taxi-trip-data-dbonetwothreefour"
}

# Glue ETL Job name
variable "glue_job_name" {
  default = "firstjobonetwothreefour"
}

# Glue Crawler name
variable "glue_crawler_name" {
  default = "nyc-crawler-onetwothreefour"
}

# Path to the ETL script in S3
# (e.g., s3://raw_bucket_name/etl/etl-glue-script.py)
variable "etl_script_s3_key" {
  default = "etl/etl-glue-script.py"
}
