

data "aws_caller_identity" "current" {}

locals {
  glue_role_name       = "AWSGlueServiceRoleDefault"
  glue_role_arn        = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.glue_role_name}"
  script_s3_path       = "s3://first-glue-bkt-grp-three-nyc/scripts/etl-glue-script.py"
  raw_data_s3_path     = "s3://first-glue-bkt-grp-three-nyc/raw_data/"
  cleaned_data_s3_path = "s3://try-ci-cd-bkt-cleanned/cleaned_data/"
}

resource "aws_glue_catalog_database" "nyc_db" {
  name = "nyc_yellow_trip_db"
}

resource "aws_glue_job" "nyc_etl_job" {
  name     = "nyc-yellow-taxi-etl-job"
  role_arn = local.glue_role_arn

  command {
    name            = "glueetl"
    script_location = local.script_s3_path
    python_version  = "3"
  }

  default_arguments = {
    "--TempDir"         = "${local.cleaned_data_s3_path}temp/"
    "--job-language"    = "python"
    "--raw_bucket"      = local.raw_data_s3_path
    "--cleaned_bucket"  = local.cleaned_data_s3_path
  }

  glue_version      = "4.0"
  number_of_workers = 2
  worker_type       = "G.1X"
  execution_property {
    max_concurrent_runs = 1
  }
}

resource "aws_glue_crawler" "nyc_crawler" {
  name          = "nyc-yellow-crawler"
  role          = local.glue_role_arn
  database_name = aws_glue_catalog_database.nyc_db.name

  s3_target {
    path = local.cleaned_data_s3_path
  }

  schedule = "cron(0 12 * * ? *)"
}
