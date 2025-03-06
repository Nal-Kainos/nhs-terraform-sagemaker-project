variable "ami" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "security_group_names" {
  description = "List of security group names for the EC2 instance"
  type        = list(string)
}
