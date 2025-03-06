variable "region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for SageMaker and other resources"
  type        = string
}

variable "db_username" {
  description = "Username for the RDS Postgres database"
  type        = string
}

variable "db_password" {
  description = "Password for the RDS Postgres database"
  type        = string
  sensitive   = true
}

variable "ami" {
  description = "AMI for EC2 instance"
  type        = string
}
