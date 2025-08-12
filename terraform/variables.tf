variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "create_bucket" {
  description = "If true Terraform will create the S3 bucket. If false, it will use existing_bucket_name"
  type        = bool
  default     = true
}

variable "existing_bucket_name" {
  description = "Name of existing S3 bucket to use when create_bucket = false"
  type        = string
  default     = ""
}

variable "bucket_name_prefix" {
  description = "Prefix for S3 bucket name when create_bucket = true"
  type        = string
  default     = "my-etl-bucket-pranav"
}

variable "glue_db_name_prefix" {
  description = "Glue database name prefix"
  type        = string
  default     = "my_etl_db"
}

variable "glue_job_name_prefix" {
  description = "Glue job name prefix"
  type        = string
  default     = "glue-etl-job"
}

variable "glue_crawler_name_prefix" {
  description = "Glue crawler name prefix"
  type        = string
  default     = "my-etl-crawler"
}

variable "glue_role_arn" {
  description = "IAM Role ARN for Glue to assume (must exist with proper permissions)"
  type        = string
  default     = "arn:aws:iam::YOUR_ACCOUNT_ID:role/LabRole"
}

variable "local_script_path" {
  description = "Local path of the Glue script to upload"
  type        = string
  default     = "etl/etl-glue-script.py"
}
