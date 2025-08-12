# S3 bucket for ETL data/scripts
resource "aws_s3_bucket" "etl_bucket" {
  bucket = var.bucket_name
}

# S3 bucket policy to allow Glue access
resource "aws_s3_bucket_policy" "glue_access" {
  bucket = aws_s3_bucket.etl_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowGlueAccess",
        Effect = "Allow",
        Principal = {
          AWS = var.glue_role_arn
        },
        Action   = ["s3:*"],
        Resource = [
          "${aws_s3_bucket.etl_bucket.arn}",
          "${aws_s3_bucket.etl_bucket.arn}/*"
        ]
      }
    ]
  })
}

# Glue Database
resource "aws_glue_catalog_database" "etl_db" {
  name = var.glue_db_name
}

# Glue Job
resource "aws_glue_job" "etl_job" {
  name     = var.glue_job_name
  role_arn = var.glue_role_arn

  command {
    name            = "glueetl"
    script_location = var.glue_script_s3_path
    python_version  = "3"
  }

  glue_version = "4.0"
}

# Glue Crawler
resource "aws_glue_crawler" "etl_crawler" {
  name         = var.glue_crawler_name
  role         = var.glue_role_arn
  database_name = aws_glue_catalog_database.etl_db.name

  s3_target {
    path = "s3://${var.bucket_name}/"
  }
}
