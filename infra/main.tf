locals {
  etl_bucket_name    = var.etl_bucket_name
  timestamp          = formatdate("YYYYMMDDhhmmss", timestamp())

  glue_job_name      = "nyc-yellow-taxi-data-${local.timestamp}"
  glue_db_name       = "nyc-yellow-taxi-data-${local.timestamp}-db"
  glue_crawler_name  = "nyc-yellow-taxi-data-${local.timestamp}-crawler"

  glue_role_arn      = "arn:aws:iam::963702399712:role/LabRole"
}

resource "aws_glue_catalog_database" "etl_db" {
  name = local.glue_db_name
}

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

resource "aws_glue_crawler" "etl_crawler" {
  name          = local.glue_crawler_name
  role          = local.glue_role_arn
  database_name = aws_glue_catalog_database.etl_db.name

  s3_target {
    path = "s3://raw-data-grp-3/cleaned-data/transformeddata/dataset/"
  }

  configuration = jsonencode({
    Version = 1.0
    CrawlerOutput = {
      Tables = {
        AddOrUpdateBehavior = "MergeNewColumns"
      }
    }
  })

  recrawl_policy {
    recrawl_behavior = "CRAWL_EVERYTHING"
  }

  depends_on = [aws_glue_job.etl_job]
}


# Trigger to start ETL Job on demand (or can make it scheduled)
resource "aws_glue_trigger" "start_etl_job" {
  name     = "start-etl-job-${local.timestamp}"
  type     = "ON_DEMAND"

  actions {
    job_name = aws_glue_job.etl_job.name
  }
}

# Trigger to start crawler after ETL job finishes successfully
resource "aws_glue_trigger" "start_crawler_after_job" {
  name     = "start-crawler-after-job-${local.timestamp}"
  type     = "CONDITIONAL"

  predicate {
    conditions {
      job_name = aws_glue_job.etl_job.name
      state    = "SUCCEEDED"
    }
  }

  actions {
    crawler_name = aws_glue_crawler.etl_crawler.name
  }

  depends_on = [aws_glue_trigger.start_etl_job]
}
