resource "aws_sagemaker_notebook_instance" "this" {
  name                  = var.name
  instance_type         = var.instance_type
  role_arn              = var.role_arn
  subnet_id             = var.subnet_id
  lifecycle_config_name = var.lifecycle_config_name

  tags = {
    Name        = var.name
    Environment = "dev"      # Adjust as needed (e.g., "prod")
    Project     = "NHS-Terraform-SageMaker"
  }
}

output "notebook_url" {
  value       = aws_sagemaker_notebook_instance.this.url
  description = "URL for the SageMaker Notebook instance"
}
