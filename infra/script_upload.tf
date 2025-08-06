resource "aws_s3_object" "etl_script" {
  bucket = "first-glue-bkt-grp-three-nyc"
  key    = var.etl_script_s3_key
  source = "${path.module}/../etl/etl-glue-script.py"
  etag   = filemd5("${path.module}/../etl/etl-glue-script.py")
}