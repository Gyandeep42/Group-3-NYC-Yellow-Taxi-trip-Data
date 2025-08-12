variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "S3 bucket name for storing ETL data"
  default     = "my-etl-bucket-pranav"
}

variable "glue_db_name" {
  description = "Base name for Glue database"
  default     = "etl_database"
}

variable "glue_job_name" {
  description = "Base name for Glue job"
  default     = "glue-etl-job"
}

variable "crawler_name" {
  description = "Base name for Glue crawler"
  default     = "my-etl-crawler"
}

variable "script_path" {
  description = "Path to Glue ETL script in S3"
  default     = "etl/etl-glue-script.py"
}
