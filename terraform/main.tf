
resource "random_string" "suffix" {
  length  = 6
  upper   = false
  special = false
}



resource "aws_s3_bucket" "etl_bucket" {
  bucket        = "${var.bucket_name_prefix}-${random_string.suffix.result}"
  force_destroy = true
}

# Disable Block Public Access so we can apply a public policy
resource "aws_s3_bucket_public_access_block" "disable_block" {
  bucket = aws_s3_bucket.etl_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Public read policy
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

  depends_on = [aws_s3_bucket_public_access_block.disable_block]
}



resource "aws_glue_catalog_database" "etl_db" {
  name = "nyc-taxi-trip-db-${random_string.suffix.result}"
}

locals {
  glue_role_arn = "arn:aws:iam::914016866997:role/LabRole"
}

resource "aws_s3_object" "glue_script" {
  bucket = aws_s3_bucket.etl_bucket.bucket
  key    = "scripts/etl-glue-script.py"
  source = "${path.module}/../etl/etl-glue-script.py" # Adjust path if needed
  etag   = filemd5("${path.module}/../etl/etl-glue-script.py")
}

resource "aws_glue_job" "etl_job" {
    name = "${var.glue_job_name}-${random_string.suffix.result}"
    role_arn = local.glue_role_arn

  command {
    name            = "glueetl"
    script_location = local.script_s3_path
    python_version  = "3"
  }

  glue_version      = "4.0"
  number_of_workers = 2
  worker_type       = "G.1X"
}

depends_on = [aws_s3_object.glue_script]


resource "aws_glue_crawler" "etl_crawler" {
    name = "${var.glue_crawler_name}-${random_string.suffix.result}"
    role= local.glue_role_arn
    database_name = aws_glue_catalog_database.etl_db.name

  s3_target {
    path = "s3://inputdata-bucket-test/cleaned-data/transformeddata/"
  }


  depends_on = [aws_glue_job.etl_job]
}
#jlihoiuifawfi