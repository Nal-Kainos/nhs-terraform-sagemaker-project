variable "name" {
  description = "Identifier for the RDS instance"
  type        = string
}

variable "db_username" {
  description = "Username for the Postgres database"
  type        = string
}

variable "db_password" {
  description = "Password for the Postgres database"
  type        = string
  sensitive   = true
}

variable "security_group_ids" {
  description = "List of security group IDs for the RDS instance"
  type        = list(string)
}
