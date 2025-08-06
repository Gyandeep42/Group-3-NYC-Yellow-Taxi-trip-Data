variable "region" {
  default = "us-east-1"
}

variable "glue_db_name" {
  default = "nyc_yellow_taxi_db"
}

variable "crawler_name" {
  default = "nyc_yellow_taxi_crawler"
}

variable "s3_raw_path" {
  default = "s3://first-glue-bkt-grp-three-nyc/raw_data/"
}

variable "crawler_role_arn" {
  default = "arn:aws:iam::963702399712:role/LabRole"
}
