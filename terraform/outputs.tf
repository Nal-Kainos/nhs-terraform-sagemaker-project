output "sagemaker_notebook_url" {
  value       = module.sagemaker.notebook_url
  description = "The URL for the SageMaker Notebook instance"
}

output "rds_endpoint" {
  value       = module.rds.endpoint
  description = "RDS endpoint for Postgres"
}
