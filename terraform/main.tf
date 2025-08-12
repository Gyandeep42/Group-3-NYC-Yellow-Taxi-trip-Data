# Random ID to make bucket name unique
resource "random_id" "bucket_id" {
  byte_length = 4
}

# S3 Bucket for ETL data
resource "aws_s3_bucket" "etl_bucket" {
  bucket        = "${var.etl_bucket_prefix}-${random_id.bucket_id.hex}"
  force_destroy = true
}

# Glue Catalog Database
resource "aws_glue_catalog_database" "this" {
  name = "${var.glue_db_name}-${replace(timestamp(), ":", "-")}"
}


# Glue ETL Job
resource "aws_glue_job" "this" {
  name     = "glue-etl-job-v2" # Changed to avoid name conflict
  role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"
  
  command {
    name            = "glueetl"
    script_location = var.glue_script_s3_path
    python_version  = "3"
  }

  max_retries       = 1
  glue_version      = "3.0"
  worker_type       = "G.1X"
  number_of_workers = 2
}

# Glue Crawler
resource "aws_glue_crawler" "this" {
  name          = var.glue_crawler_name
  role          = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"
  database_name = aws_glue_catalog_database.this.name

  s3_target {
    path = "s3://${aws_s3_bucket.etl_bucket.bucket}/"
  }
}

# Get current AWS account ID
data "aws_caller_identity" "current" {}
