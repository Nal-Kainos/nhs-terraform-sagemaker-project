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

variable "lifecycle_config_name" {
  description = "Lifecycle configuration name for the Notebook instance"
  type        = string
}
