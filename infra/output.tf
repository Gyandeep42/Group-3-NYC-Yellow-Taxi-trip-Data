output "glue_job_name" {
  value = aws_glue_job.etl_job.name
}

output "glue_crawler_name" {
  value = aws_glue_crawler.etl_crawler.name
}

output "glue_database_name" {
  value = aws_glue_catalog_database.etl_db.name
}

output "bucket_name" {
  value = aws_s3_bucket.etl_bucket.bucket
}
