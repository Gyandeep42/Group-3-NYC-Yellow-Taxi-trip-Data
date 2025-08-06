provider "aws" {
  region = "us-east-1"
}

locals {
  glue_role_arn = "arn:aws:iam::963702399712:role/labrole"  # Replace with actual
}

resource "aws_glue_catalog_database" "etl_db" {
  name = "nyc_yellow_taxi_etl_db"
}

resource "aws_glue_job" "etl_job" {
  name     = var.glue_job_name
  role_arn = local.glue_role_arn

  command {
    name            = "glueetl"
    script_location = var.script_s3_path
    python_version  = "3"
  }

  glue_version      = "4.0"
  number_of_workers = 2
  worker_type       = "G.1X"

  default_arguments = {
    "--job-language"                      = "python"
    "--TempDir"                           = "s3://${var.bucket_name_prefix}/temp/"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-metrics"                   = "true"
  }

  depends_on = [aws_glue_catalog_database.etl_db]
}

resource "aws_glue_crawler" "etl_crawler" {
  name          = var.glue_crawler_name
  role          = local.glue_role_arn
  database_name = aws_glue_catalog_database.etl_db.name

  s3_target {
    path = "s3://${var.bucket_name_prefix}/cleaned_data/"
  }

  depends_on = [aws_glue_job.etl_job]
}
