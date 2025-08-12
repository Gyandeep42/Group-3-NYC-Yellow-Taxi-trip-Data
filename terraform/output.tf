output "resolved_bucket_name" {
  description = "Bucket used for ETL (created or existing)"
  value       = local.resolved_bucket_name
}

output "script_s3_path" {
  description = "S3 path to uploaded ETL script"
  value       = local.script_s3_path
}

output "glue_db_name" {
  description = "Glue database name"
  value       = aws_glue_catalog_database.etl_db.name
}

output "glue_job_name" {
  description = "Glue job name (created)"
  value       = aws_glue_job.etl_job.name
}

output "glue_crawler_name" {
  description = "Glue crawler name (created)"
  value       = aws_glue_crawler.etl_crawler.name
}
