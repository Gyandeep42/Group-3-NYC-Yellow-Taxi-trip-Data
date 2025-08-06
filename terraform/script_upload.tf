#resource "aws_s3_object" "etl_script" {
# bucket = var.raw_bucket_name
#  key    = var.etl_script_s3_key
#  source = "${path.module}/../etl/etl-glue-script.py"
#  etag   = filemd5("${path.module}/../etl/etl-glue-script.py")

  # 👇 Ensure bucket is created before uploading
#  depends_on = [aws_s3_bucket.raw_bucket]
#}
