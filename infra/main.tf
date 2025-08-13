# Glue Database
resource "aws_glue_catalog_database" "nyc_db" {
  name = "nyc-yellow-taxi-trip-data"
}

# Glue Job
resource "aws_glue_job" "etl_job" {
  name     = "glue-etl-job"
  role_arn = var.glue_role_arn

  command {
    name            = "glueetl"
    script_location = "s3://${var.scripts_bucket}/etl-glue-script.py"
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"                                = "s3://${var.temp_bucket}/tmp/"
    "--job-language"                           = "python"
    "--enable-metrics"                         = "true"
    "--enable-continuous-cloudwatch-log"       = "true"
    "--output_path"                            = "s3://${var.cleaned_bucket}/transformeddata/dataset/"
  }

  glue_version = "3.0"
  max_capacity = 2
}

# Glue Crawler
resource "aws_glue_crawler" "nyc_crawler" {
  name          = "nyc-crawler"
  role          = var.glue_role_arn
  database_name = aws_glue_catalog_database.nyc_db.name

  s3_target {
    path = "s3://${var.cleaned_bucket}/transformeddata/dataset/"
  }

  depends_on = [aws_glue_job.etl_job]
}
