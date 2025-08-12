output "etl_bucket_name" {
  description = "Name of the ETL S3 bucket"
  value       = aws_s3_bucket.etl_bucket.bucket
}

output "glue_job_name" {
  description = "Name of the Glue ETL Job"
  value       = aws_glue_job.etl_job.name
}

output "glue_crawler_name" {
  description = "Name of the Glue Crawler"
  value       = aws_glue_crawler.etl_crawler.name
}
