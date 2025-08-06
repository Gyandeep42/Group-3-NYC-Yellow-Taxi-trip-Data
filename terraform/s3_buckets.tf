resource "aws_s3_bucket" "source_bucket" {
  bucket = var.raw_bucket_name

  tags = {
    Name = "Raw Data Bucket"
  }
}

resource "aws_s3_bucket" "target_bucket" {
  bucket = var.cleaned_bucket_name

  tags = {
    Name = "Cleaned Data Bucket"
  }
}
