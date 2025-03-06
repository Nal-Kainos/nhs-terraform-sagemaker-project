variable "name" {
  description = "Name of the SageMaker Notebook instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the SageMaker Notebook"
  type        = string
}

variable "role_arn" {
  description = "IAM Role ARN for the SageMaker Notebook"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for the SageMaker Notebook"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "lifecycle_config_name" {
  description = "Lifecycle configuration name for the notebook instance"
  type        = string
}
