variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "backend_bucket" {
  description = "S3 bucket for Terraform backend"
  type        = string
  default     = "my-terraform-backend-bucket"
}

variable "backend_key" {
  description = "Path/key for Terraform state file"
  type        = string
  default     = "terraform/state.tfstate"
}

variable "glue_script_s3_path" {
  description = "S3 path for Glue ETL script"
  type        = string
  default     = "s3://my-etl-scripts/etl-glue-script.py"
}


variable "etl_bucket_prefix" {
  description = "Prefix for ETL S3 bucket"
  type        = string
  default     = "my-etl-bucket"
}

variable "glue_db_name" {
  description = "Name of Glue Catalog database"
  type        = string
  default     = "etl_database"
}

variable "glue_job_name" {
  description = "Name of Glue ETL Job"
  type        = string
  default     = "glue-etl-job"
}

variable "glue_crawler_name" {
  description = "Name of Glue crawler"
  type        = string
  default     = "etl-crawler"
}

variable "glue_script_s3_path" {
  description = "S3 path to Glue ETL script"
  type        = string
}
