locals {
  # Use the bucket name from variables.tf
  etl_bucket_name = var.etl_bucket_name

  # Generate timestamp
  timestamp = formatdate("YYYYMMDDhhmmss", timestamp())

  # Auto-generated names for resources
  glue_job_name      = "nyc-yellow-taxi-data-${local.timestamp}"
  glue_db_name       = "nyc-yellow-taxi-data-${local.timestamp}-db"
  glue_crawler_name  = "nyc-yellow-taxi-data-${local.timestamp}-crawler"
  glue_workflow_name = "nyc-yellow-taxi-data-${local.timestamp}-workflow"

  glue_role_arn = "arn:aws:iam::963702399712:role/LabRole"
}

# Glue Database
resource "aws_glue_catalog_database" "etl_db" {
  name = local.glue_db_name
}

# Glue Job
resource "aws_glue_job" "etl_job" {
  name     = local.glue_job_name
  role_arn = local.glue_role_arn

  command {
    name            = "glueetl"
    script_location = "s3://${local.etl_bucket_name}/scripts/latest/etl-glue-script.py"
    python_version  = "3"
  }

  glue_version      = "4.0"
  number_of_workers = 2
  worker_type       = "G.1X"
}

# Glue Crawler
resource "aws_glue_crawler" "etl_crawler" {
  name          = local.glue_crawler_name
  role          = local.glue_role_arn
  database_name = aws_glue_catalog_database.etl_db.name

  s3_target {
    path = "s3://raw-data-grp-3/cleaned-data/transformeddata/"
  }
}

# Glue Workflow
resource "aws_glue_workflow" "etl_workflow" {
  name = local.glue_workflow_name
}

# Trigger to start job when workflow runs
resource "aws_glue_trigger" "start_etl_job" {
  name     = "trigger-job-${local.timestamp}"
  type     = "WORKFLOW"
  workflow_name = aws_glue_workflow.etl_workflow.name

  actions {
    job_name = aws_glue_job.etl_job.name
  }
}

# Trigger to start crawler after job completes
resource "aws_glue_trigger" "start_crawler_after_job" {
  name     = "trigger-crawler-${local.timestamp}"
  type     = "CONDITIONAL"
  workflow_name = aws_glue_workflow.etl_workflow.name

  predicate {
    conditions {
      job_name = aws_glue_job.etl_job.name
      state    = "SUCCEEDED"
    }
  }

  actions {
    crawler_name = aws_glue_crawler.etl_crawler.name
  }
}
