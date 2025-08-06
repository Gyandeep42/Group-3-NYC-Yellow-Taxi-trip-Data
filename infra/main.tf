resource "aws_glue_catalog_database" "yellow_taxi_db" {
  name = var.glue_db_name
}

resource "aws_glue_crawler" "yellow_taxi_crawler" {
  name          = var.crawler_name
  role          = var.crawler_role_arn
  database_name = aws_glue_catalog_database.yellow_taxi_db.name

  s3_target {
    path = var.s3_raw_path
  }

  depends_on = [aws_glue_catalog_database.yellow_taxi_db]
}
