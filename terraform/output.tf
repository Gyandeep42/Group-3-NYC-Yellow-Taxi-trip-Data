output "etl_bucket_name" {
  description = "The name of the ETL S3 bucket"
  value       = aws_s3_bucket.etl_bucket.bucket
}

output "glue_db_name" {
  description = "The name of the Glue Catalog Database"
  value       = aws_glue_catalog_database.this.name
}

output "glue_job_name" {
  description = "The name of the Glue ETL Job"
  value       = aws_glue_job.this.name
}

output "glue_crawler_name" {
  description = "The name of the Glue Crawler"
  value       = aws_glue_crawler.this.name
}
