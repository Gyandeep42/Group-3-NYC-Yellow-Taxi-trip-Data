
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}

resource "aws_s3_bucket" "etl_bucket" {
  bucket        = "${var.bucket_name_prefix}-${random_string.suffix.result}"
  force_destroy = true
}

resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.etl_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.etl_bucket.arn}/*"
      }
    ]
  })
}



resource "aws_glue_catalog_database" "etl_db" {
  name = "nyc-taxi-trip-db-${random_string.suffix.result}"
}

locals {
  glue_role_arn = "arn:aws:iam::914016866997:role/LabRole"
}

resource "aws_glue_job" "etl_job" {
    name = "${var.glue_job_name}-${random_string.suffix.result}"
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

resource "aws_glue_crawler" "etl_crawler" {
    name = "${var.glue_crawler_name}-${random_string.suffix.result}"
  role          = local.glue_role_arn
  database_name = aws_glue_catalog_database.etl_db.name

  s3_target {
    path = "s3://inputdata-bucket-test/cleaned-data/transformeddata/"
  }

  depends_on = [aws_glue_job.etl_job]
}
#jlihoiuifawfi