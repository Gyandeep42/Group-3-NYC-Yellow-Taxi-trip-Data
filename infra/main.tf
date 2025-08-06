provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "etl_bucket" {
  bucket = var.bucket_name
  acl    = "private"

  force_destroy = true

  tags = {
    Name        = "ETL Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "allow_public_access" {
  bucket                  = aws_s3_bucket.etl_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
