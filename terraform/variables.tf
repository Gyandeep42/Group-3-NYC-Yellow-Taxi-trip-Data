variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "etl_bucket_name" {
  description = "S3 bucket name for ETL"
  type        = string
  default     = "my-etl-bucket-${random_id.bucket_id.hex}"
}

variable "glue_db_name" {
  description = "Glue database name"
  type        = string
  default     = "my_etl_db"
}

variable "glue_job_name" {
  description = "Glue ETL job name"
  type        = string
  default     = "glue-etl-job"
}

variable "glue_crawler_name" {
  description = "Glue crawler name"
  type        = string
  default     = "my-etl-crawler"
}

variable "glue_role_arn" {
  description = "IAM role ARN for Glue job"
  type        = string
}
