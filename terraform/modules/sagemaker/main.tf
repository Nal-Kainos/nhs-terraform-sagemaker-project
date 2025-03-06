resource "aws_sagemaker_notebook_instance" "this" {
  name                  = var.name
  instance_type         = var.instance_type
  role_arn              = var.role_arn
  subnet_id             = var.subnet_id
  security_group_ids    = var.security_group_ids
  lifecycle_config_name = var.lifecycle_config_name

  tags = {
    Name        = var.name
    Environment = "dev"           # Update as necessary (e.g., "prod")
    Project     = "NHS-Terraform-SageMaker"
  }
}

output "notebook_url" {
  value       = aws_sagemaker_notebook_instance.this.url
  description = "The URL for the SageMaker Notebook instance"
}
