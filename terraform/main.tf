provider "aws" {
  region = var.region
}


# resource "aws_s3_bucket" "raw_bucket" {
#   bucket = var.try-ci-cd-bkt-raw
# }

# resource "aws_s3_bucket" "cleaned_bucket" {
#   bucket = var.try-ci-cd-bkt-cleanned
# }


locals {
  glue_role_arn       = "arn:aws:iam::298417083584:role/LabRole"
  raw_bucket_name     = var.try-ci-cd-bkt-raw
  cleaned_bucket_name = var.try-ci-cd-bkt-cleanned
}



# Create Glue Catalog Database
resource "aws_glue_catalog_database" "glue_db" {
  name = var.glue_db_name
}

# Create Glue ETL Job
resource "aws_glue_job" "glue_etl_job" {
  name     = var.glue_job_name
  role_arn = local.glue_role_arn

  command {
    name            = "glueetl"
    script_location = "s3://${local.raw_bucket_name}/${var.etl_script_s3_key}"
    python_version  = "3"
  }

  default_arguments = {
    "--job-language" = "python"
    "--SOURCE_PATH"  = "s3://${local.raw_bucket_name}/processed-output/"
    "--TARGET_PATH"  = "s3://${local.cleaned_bucket_name}/cleaned/"
  }

  glue_version      = "4.0"
  number_of_workers = 2
  worker_type       = "G.1X"
}

# Create Glue Crawler
resource "aws_glue_crawler" "glue_crawler" {
  name          = var.glue_crawler_name
  role          = local.glue_role_arn
  database_name = aws_glue_catalog_database.glue_db.name

  s3_target {
    path = "s3://${var.cleaned_bucket_name}/cleaned/"
  }

  depends_on = [aws_glue_job.glue_etl_job]
}

# Optional: Get account details (useful if needed for debugging)
data "aws_caller_identity" "current" {}
