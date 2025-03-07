variable "region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "environment" {
  description = "Environment tag (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "subnet_id" {
  description = "Subnet ID for deploying resources like SageMaker"
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
