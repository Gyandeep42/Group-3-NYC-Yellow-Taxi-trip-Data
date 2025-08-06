output "source_bucket" {
  value = var.raw_bucket_name
}

output "target_bucket" {
  value = var.cleaned_bucket_name
}

output "glue_database_name" {
  value = aws_glue_catalog_database.glue_db.name
}

output "glue_job_name" {
  value = aws_glue_job.glue_etl_job.name
}

output "glue_crawler_name" {
  value = aws_glue_crawler.glue_crawler.name
}
