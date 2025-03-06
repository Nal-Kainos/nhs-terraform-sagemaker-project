resource "aws_db_instance" "postgres" {
  identifier             = var.name
  engine                 = "postgres"
  instance_class         = "db.t2.micro"
  allocated_storage      = 20
  username               = var.db_username
  password               = var.db_password
  vpc_security_group_ids = var.security_group_ids
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name        = var.name
    Environment = "dev"
    Project     = "NHS-Terraform-SageMaker"
  }
}

output "endpoint" {
  value       = aws_db_instance.postgres.address
  description = "The endpoint for the Postgres database"
}
