variable "aws_account_id" {
  description = "AWS Account ID from GitHub Actions"
  type        = string
}

variable "timestamp" {
  description = "Deployment timestamp"
  type        = string
}

variable "bucket_name_prefix" {
  description = "Existing S3 bucket name where scripts and data will be stored"
  type        = string
}

# Allow public access by disabling block public access
resource "aws_s3_bucket_public_access_block" "allow_public" {
  bucket                  = var.bucket_name_prefix
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Make bucket publicly readable
resource "aws_s3_bucket_acl" "public_acl" {
  bucket = var.bucket_name_prefix
  acl    = "public-read"
}

# Glue database with timestamp in name
resource "aws_glue_catalog_database" "etl_db" {
  name = "nyc-taxi-trip-db-${var.timestamp}"
}

locals {
  glue_role_arn = "arn:aws:iam::${var.aws_account_id}:role/LabRole"
}

# Glue ETL job with timestamp in name
resource "aws_glue_job" "etl_job" {
  name     = "${var.glue_job_name}-${var.timestamp}"
  role_arn = local.glue_role_arn

  command {
    name            = "glueetl"
    script_location = var.script_s3_path
    python_version  = "3"
  }

  glue_version      = "4.0"
  number_of_workers = 2
  worker_type       = "G.1X"
}

# Glue crawler with timestamp in name
resource "aws_glue_crawler" "etl_crawler" {
  name          = "${var.glue_crawler_name}-${var.timestamp}"
  role          = local.glue_role_arn
  database_name = aws_glue_catalog_database.etl_db.name

  s3_target {
    path = "s3://${var.bucket_name_prefix}/cleaned-data/transformeddata/"
  }

  depends_on = [aws_glue_job.etl_job]
}
