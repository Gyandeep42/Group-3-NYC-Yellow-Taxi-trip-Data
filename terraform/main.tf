# provider "aws" {
#   region = var.region
# }

locals {
  glue_role_arn = "arn:aws:iam::298417083584:role/LabRole"
}

# Commented out if buckets already exist
# resource "aws_s3_bucket" "raw_bucket" {
#   bucket = var.raw_bucket_name
# }

# resource "aws_s3_bucket" "cleaned_bucket" {
#   bucket = var.cleaned_bucket_name
# }

data "aws_glue_catalog_database" "existing_db" {
  name = var.glue_db_name
}

# resource "aws_glue_job" "glue_etl_job" {
#   name     = var.glue_job_name
#   role_arn = local.glue_role_arn

#   command {
#     name            = "glueetl"
#     script_location = "s3://${var.raw_bucket_name}/${var.etl_script_s3_key}"
#     python_version  = "3"
#   }

#   default_arguments = {
#     "--job-language" = "python"
#     "--SOURCE_PATH"  = "s3://${var.raw_bucket_name}/processed-output/"
#     "--TARGET_PATH"  = "s3://${var.cleaned_bucket_name}/cleaned/"
#   }

#   glue_version      = "4.0"
#   number_of_workers = 2
#   worker_type       = "G.1X"
# }

data "aws_glue_job" "existing_job" {
  name = var.glue_job_name
}


resource "aws_glue_crawler" "glue_crawler" {
  name          = var.glue_crawler_name
  role          = local.glue_role_arn
  database_name = data.aws_glue_catalog_database.existing_db.name

  s3_target {
    path = "s3://${var.cleaned_bucket_name}/cleaned/"
  }

  depends_on = [data.aws_glue_job.existing_job]
}


data "aws_caller_identity" "current" {}
