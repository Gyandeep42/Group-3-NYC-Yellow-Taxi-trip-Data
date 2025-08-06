output "glue_database_name" {
  value = aws_glue_catalog_database.yellow_taxi_db.name
}

output "glue_crawler_name" {
  value = aws_glue_crawler.yellow_taxi_crawler.name
}
