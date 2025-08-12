# ===== Variables =====
variable "region" {
  default = "us-east-1"
}

variable "etl_bucket_name" {
  default = "third-glue-bkt-grp-three-nyc" # Permanent bucket
}

variable "glue_job_name" {
  default = "glue-etl-job"
}

variable "glue_crawler_name" {
  default = "my-etl-crawler"
}

# ===== Data Source: Existing Bucket =====
data "aws_s3_bucket" "etl_bucket" {
  bucket = var.etl_bucket_name
}

# ===== Local Variables =====
locals {
  glue_role_arn   = "arn:aws:iam::914016866997:role/LabRole"
  run_folder      = formatdate("YYYYMMDD-HHmmss", timestamp())
  script_s3_path  = "s3://${var.etl_bucket_name}/scripts/${local.run_folder}/etl-glue-script.py"
  transformed_path = "s3://${var.etl_bucket_name}/cleaned-data/${local.run_folder}/"
}

# ===== Glue Database =====
resource "aws_glue_catalog_database" "etl_db" {
  name = "nyc-taxi-trip-db"
}

# ===== Upload Glue Script =====
resource "aws_s3_object" "glue_script" {
  bucket = var.etl_bucket_name
  key    = "scripts/${local.run_folder}/etl-glue-script.py"
  source = "${path.module}/../etl/etl-glue-script.py"
  etag   = filemd5("${path.module}/../etl/etl-glue-script.py")
}

# ===== Glue Job =====
resource "aws_glue_job" "etl_job" {
  name     = var.glue_job_name
  role_arn = local.glue_role_arn

  command {
    name            = "glueetl"
    script_location = local.script_s3_path
    python_version  = "3"
  }

  glue_version      = "4.0"
  number_of_workers = 2
  worker_type       = "G.1X"
  depends_on        = [aws_s3_object.glue_script]
}

# ===== Glue Crawler =====
resource "aws_glue_crawler" "etl_crawler" {
  name          = var.glue_crawler_name
  role          = local.glue_role_arn
  database_name = aws_glue_catalog_database.etl_db.name

  s3_target {
    path = local.transformed_path
  }

  depends_on = [aws_glue_job.etl_job]
}

# ===== Outputs =====
output "etl_bucket_name" {
  value = var.etl_bucket_name
}

output "glue_job_name" {
  value = aws_glue_job.etl_job.name
}

output "glue_crawler_name" {
  value = aws_glue_crawler.etl_crawler.name
}
