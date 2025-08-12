# ===============================
# Provider Configuration
# ===============================
provider "aws" {
  region = var.region
}

# ===============================
# Variables
# ===============================
variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "glue_db_name" {
  description = "Name of the Glue database"
  type        = string
  default     = "my_glue_db"
}

variable "glue_job_name" {
  description = "Name of the Glue ETL job"
  type        = string
  default     = "glue-etl-job"
}

variable "glue_crawler_name" {
  description = "Name of the Glue crawler"
  type        = string
  default     = "my-etl-crawler"
}

variable "script_file" {
  description = "Local path to Glue ETL script"
  type        = string
  default     = "etl/etl-glue-script.py"
}

# ===============================
# Locals
# ===============================
locals {
  script_s3_path = "s3://${aws_s3_bucket.etl_scripts.bucket}/scripts/${basename(var.script_file)}"
}

# ===============================
# S3 Bucket for Scripts
# ===============================
resource "aws_s3_bucket" "etl_scripts" {
  bucket = "etl-scripts-${random_id.bucket_suffix.hex}"
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

resource "aws_s3_object" "glue_script" {
  bucket = aws_s3_bucket.etl_scripts.bucket
  key    = "scripts/${basename(var.script_file)}"
  source = var.script_file
}

# ===============================
# Glue Database
# ===============================
resource "aws_glue_catalog_database" "this" {
  name = var.glue_db_name
}

# ===============================
# Glue Job
# ===============================
resource "aws_glue_job" "this" {
  name     = var.glue_job_name
  role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"

  command {
    name            = "glueetl"
    script_location = local.script_s3_path
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir" = "s3://${aws_s3_bucket.etl_scripts.bucket}/temp/"
  }

  glue_version = "4.0"
  max_capacity = 2
}

# ===============================
# Glue Crawler
# ===============================
resource "aws_glue_crawler" "this" {
  name          = var.glue_crawler_name
  role          = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/LabRole"
  database_name = aws_glue_catalog_database.this.name

  s3_target {
    path = "s3://${aws_s3_bucket.etl_scripts.bucket}/output/"
  }

  schedule = "cron(0 12 * * ? *)"
}

# ===============================
# Data Sources
# ===============================
data "aws_caller_identity" "current" {}

# ===============================
# Outputs
# ===============================
output "etl_bucket_name" {
  value = aws_s3_bucket.etl_scripts.bucket
}

output "glue_job_name" {
  value = aws_glue_job.this.name
}

output "glue_crawler_name" {
  value = aws_glue_crawler.this.name
}
