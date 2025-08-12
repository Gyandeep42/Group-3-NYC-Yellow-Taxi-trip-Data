variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "etl_bucket_name" {
  description = "Name of the S3 bucket for ETL scripts and data"
  type        = string
  default     = "my-etl-bucket-pranav"
}

variable "glue_db_name" {
  description = "Name of the Glue Catalog Database"
  type        = string
  default     = "my_etl_db"
}

variable "glue_job_name" {
  description = "Name of the AWS Glue ETL Job"
  type        = string
  default     = "glue-etl-job"
}

variable "glue_crawler_name" {
  description = "Name of the AWS Glue Crawler"
  type        = string
  default     = "my-etl-crawler"
}

variable "glue_role_arn" {
  description = "IAM Role ARN for Glue to access resources"
  type        = string
  default     = "arn:aws:iam::YOUR_ACCOUNT_ID:role/LabRole"
}

variable "script_s3_key" {
  description = "S3 key (path) for the Glue ETL script"
  type        = string
  default     = "scripts/etl-glue-script.py"
}
