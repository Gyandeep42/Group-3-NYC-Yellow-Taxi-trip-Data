resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "etl_bucket" {
  bucket = var.etl_bucket_name
}

resource "aws_s3_bucket_policy" "glue_access" {
  bucket = aws_s3_bucket.etl_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowGlueReadWrite"
        Effect    = "Allow"
        Principal = {
          AWS = var.glue_role_arn
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          "${aws_s3_bucket.etl_bucket.arn}/*",
          aws_s3_bucket.etl_bucket.arn
        ]
      }
    ]
  })
}

resource "aws_glue_catalog_database" "etl_db" {
  name = var.glue_db_name
}

resource "aws_glue_job" "etl_job" {
  name     = var.glue_job_name
  role_arn = var.glue_role_arn

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.etl_bucket.bucket}/etl/etl-glue-script.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir" = "s3://${aws_s3_bucket.etl_bucket.bucket}/temp/"
  }
}

resource "aws_glue_crawler" "etl_crawler" {
  name         = var.glue_crawler_name
  role         = var.glue_role_arn
  database_name = aws_glue_catalog_database.etl_db.name

  s3_target {
    path = "s3://${aws_s3_bucket.etl_bucket.bucket}/"
  }
}
