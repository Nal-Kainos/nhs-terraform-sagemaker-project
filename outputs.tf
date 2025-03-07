output "rds_endpoint" {
  value       = module.rds.endpoint
  description = "Endpoint for the RDS Postgres database"
}
