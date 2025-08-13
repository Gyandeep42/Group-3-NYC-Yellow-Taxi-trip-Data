output "glue_job_name" {
  value = aws_glue_job.etl_job.name
}

output "crawler_name" {
  value = aws_glue_crawler.nyc_crawler.name
}

output "glue_database_name" {
  value = aws_glue_catalog_database.nyc_db.name
}
