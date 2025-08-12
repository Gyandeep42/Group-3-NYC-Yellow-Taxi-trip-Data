# S3 bucket for ETL scripts and data
resource "aws_s3_bucket" "etl_bucket" {
  bucket = var.etl_bucket_name

  tags = {
    Name        = "ETL Bucket"
    Environment = "Dev"
  }
}

# S3 bucket policy to allow Glue access
resource "aws_s3_bucket_policy" "glue_access" {
  bucket = aws_s3_bucket.etl_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowGlueReadWrite",
        Effect    = "Allow",
        Principal = {
          AWS = var.glue_role_arn
        },
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.etl_bucket.arn}",
          "${aws_s3_bucket.etl_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Glue Catalog Database
resource "aws_glue_catalog_database" "etl_db" {
  name = var.glue_db_name
}

# Glue ETL Job
resource "aws_glue_job" "etl_job" {
  name     = var.glue_job_name
  role_arn = var.glue_role_arn

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.etl_bucket.bucket}/${var.script_s3_key}"
    python_version  = "3"
  }

  max_retries = 1
  glue_version = "3.0"

  default_arguments = {
    "--job-language" = "python"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-metrics" = "true"
  }
}

# Glue Crawler
resource "aws_glue_crawler" "etl_crawler" {
  name         = var.glue_crawler_name
  role         = var.glue_role_arn
  database_name = aws_glue_catalog_database.etl_db.name

  s3_target {
    path = "s3://${aws_s3_bucket.etl_bucket.bucket}/"
  }

  schedule = "cron(0 12 * * ? *)"

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }
}
