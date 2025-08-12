terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# random suffix to avoid collisions
resource "random_id" "suffix" {
  byte_length = 4
}

locals {
  suffix          = lower(random_id.suffix.hex)
  run_folder      = "run-${local.suffix}"
  # bucket name chosen depending on create_bucket
  bucket_name     = var.create_bucket ? "${var.bucket_name_prefix}-${local.suffix}" : var.existing_bucket_name
  glue_db_name    = "${var.glue_db_name_prefix}-${local.suffix}"
  glue_job_name   = "${var.glue_job_name_prefix}-${local.suffix}"
  glue_crawler_name = "${var.glue_crawler_name_prefix}-${local.suffix}"

  script_s3_key   = "scripts/${local.run_folder}/${basename(var.local_script_path)}"
  script_s3_path  = "s3://${local.bucket_name}/${local.script_s3_key}"
  output_prefix   = "cleaned-data/${local.run_folder}/"
}

# Optionally create an S3 bucket (count = 1 when create_bucket true)
resource "aws_s3_bucket" "etl_bucket" {
  count  = var.create_bucket ? 1 : 0
  bucket = "${var.bucket_name_prefix}-${local.suffix}"

  tags = {
    Name = "ETL Bucket"
    Run  = local.run_folder
  }
}

# If using existing bucket, validate via data source (when not creating)
data "aws_s3_bucket" "existing" {
  count  = var.create_bucket ? 0 : 1
  bucket = var.existing_bucket_name
}

# Bucket to use (either created or existing)
# use conditional lookup: if created, use aws_s3_bucket.etl_bucket[0].bucket else data.aws_s3_bucket.existing[0].bucket
locals {
  resolved_bucket_name = var.create_bucket ? aws_s3_bucket.etl_bucket[0].bucket : data.aws_s3_bucket.existing[0].bucket
  resolved_bucket_arn  = var.create_bucket ? aws_s3_bucket.etl_bucket[0].arn    : data.aws_s3_bucket.existing[0].arn
}

# Bucket policy to allow Glue role full object access (adjust actions as needed)
resource "aws_s3_bucket_policy" "glue_access" {
  bucket = local.resolved_bucket_name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowGlueAccess",
        Effect = "Allow",
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
          "${local.resolved_bucket_arn}",
          "${local.resolved_bucket_arn}/*"
        ]
      }
    ]
  })
}

# Upload Glue script to run-specific folder
resource "aws_s3_object" "glue_script" {
  bucket = local.resolved_bucket_name
  key    = local.script_s3_key
  source = var.local_script_path
  etag   = filemd5(var.local_script_path)
  depends_on = [aws_s3_bucket_policy.glue_access]
}

# Glue Catalog Database
resource "aws_glue_catalog_database" "etl_db" {
  name = local.glue_db_name
}

# Glue Job (definition only; not starting it)
resource "aws_glue_job" "etl_job" {
  name     = local.glue_job_name
  role_arn = var.glue_role_arn

  command {
    name            = "glueetl"
    script_location = local.script_s3_path
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir" = "s3://${local.resolved_bucket_name}/temp/"
  }

  glue_version      = "4.0"
  number_of_workers = 2
  worker_type       = "G.1X"

  # If job exists with different config AWS will error on create; lifecycle can ignore some changes if you import
  lifecycle {
    create_before_destroy = true
  }
}

# Glue Crawler (definition only; not scheduled to run during apply)
resource "aws_glue_crawler" "etl_crawler" {
  name          = local.glue_crawler_name
  role          = var.glue_role_arn
  database_name = aws_glue_catalog_database.etl_db.name

  s3_target {
    path = "s3://${local.resolved_bucket_name}/${local.output_prefix}"
  }

  # Do not provide a schedule so it does not run automatically
  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }
}
