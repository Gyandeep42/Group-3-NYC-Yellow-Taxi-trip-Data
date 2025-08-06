output "glue_job_name" {
  value = aws_glue_job.nyc_etl_job.name
}

output "glue_crawler_name" {
  value = aws_glue_crawler.nyc_crawler.name
}
