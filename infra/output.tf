output "glue_job_name" {
  value = aws_glue_job.etl_job.name
}



output "crawler_name" {
  value = aws_glue_crawler.etl_crawler.name
}