variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket for ETL scripts and data"
  type        = string
}

variable "glue_db_name" {
  description = "Name of the Glue database"
  type        = string
}

variable "glue_job_name" {
  description = "Name of the Glue ETL job"
  type        = string
}

variable "glue_crawler_name" {
  description = "Name of the Glue crawler"
  type        = string
}

variable "glue_script_s3_path" {
  description = "S3 path of the Glue ETL script"
  type        = string
}

variable "glue_role_arn" {
  description = "IAM role ARN for Glue job and crawler"
  type        = string
}
