resource "aws_instance" "this" {
  ami             = var.ami
  instance_type   = var.instance_type
  security_groups = var.security_group_names

  tags = {
    Name        = "NHS EC2 Instance"
    Environment = "dev"
    Project     = "NHS-Terraform-SageMaker"
  }
}

output "instance_id" {
  value       = aws_instance.this.id
  description = "The ID of the EC2 instance"
}
