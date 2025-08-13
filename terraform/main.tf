resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = "Dev"
  }
}

# Create dynamic folder in same bucket
resource "aws_s3_object" "script_upload" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = "scripts/${formatdate("YYYYMMDD-HHmmss", timestamp())}/etl-glue-script.py"
  source = var.script_path
}

# Glue Database (new every time with timestamp)
resource "aws_glue_catalog_database" "this" {
  name = "${lower(var.glue_db_name)}_${replace(formatdate("YYYYMMDD_HHmmss", timestamp()), "-", "_")}"
}

# Glue Job (new every time)
resource "aws_glue_job" "this" {
  name     = "${var.glue_job_name}_${replace(formatdate("YYYYMMDD_HHmmss", timestamp()), "-", "_")}"
  role_arn = "arn:aws:iam::914016866997:role/LabRole"

  command {
    name            = "glueetl"
    script_location = "s3://${aws_s3_bucket.my_bucket.bucket}/${aws_s3_object.script_upload.key}"
    python_version  = "3"
  }

  default_arguments = {
    "--job-language" = "python"
    "--enable-continuous-cloudwatch-log" = "true"
  }

  glue_version = "4.0"
}

# Glue Crawler (new every time)
resource "aws_glue_crawler" "this" {
  name          = "${var.crawler_name}_${replace(formatdate("YYYYMMDD_HHmmss", timestamp()), "-", "_")}"
  role          = "arn:aws:iam::914016866997:role/LabRole"
  database_name = aws_glue_catalog_database.this.name

  s3_target {
    path = "s3://${aws_s3_bucket.my_bucket.bucket}/data/"
  }
}
#hello