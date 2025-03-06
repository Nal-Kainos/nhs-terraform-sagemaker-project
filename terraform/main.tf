terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Define common tags to be applied to all resources
locals {
  common_tags = {
    Project     = "NHS-Terraform-SageMaker"
    Environment = "dev" # Change to 'prod' or other environment as needed
  }
}

# Deploy SageMaker Notebook via module
module "sagemaker" {
  source                = "./modules/sagemaker"
  name                  = "nhs-sagemaker"
  instance_type         = "ml.t2.medium"
  role_arn              = aws_iam_role.sagemaker_role.arn
  subnet_id             = var.subnet_id
  security_group_ids    = [aws_security_group.nhs_sg.id]
  lifecycle_config_name = "nhs-lifecycle"
}

# Deploy RDS (Postgres) via module
module "rds" {
  source             = "./modules/rds"
  name               = "nhs-postgres"
  db_username        = var.db_username
  db_password        = var.db_password
  security_group_ids = [aws_security_group.nhs_sg.id]
}

# Create an IAM role for SageMaker
resource "aws_iam_role" "sagemaker_role" {
  name = "nhs-sagemaker-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "sagemaker.amazonaws.com" }
    }]
  })
  tags = merge(local.common_tags, {
    Name = "NHS SageMaker Role"
  })
}

# Create a KMS key
resource "aws_kms_key" "nhs_kms" {
  description         = "KMS key for NHS project"
  enable_key_rotation = true
  tags                = merge(local.common_tags, { Name = "NHS KMS Key" })
}

# Create a Secrets Manager secret
resource "aws_secretsmanager_secret" "nhs_secret" {
  name = "nhs/secret"
  tags = merge(local.common_tags, { Name = "NHS Secret" })
}

# Create a security group
resource "aws_security_group" "nhs_sg" {
  name        = "nhs-sg"
  description = "Security group for NHS project"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = merge(local.common_tags, { Name = "NHS Security Group" })
}

# Create an S3 bucket
resource "aws_s3_bucket" "nhs_bucket" {
  bucket = "nhs-project-bucket-unique"
  acl    = "private"
  tags   = merge(local.common_tags, { Name = "NHS S3 Bucket" })
}

# Create an EC2 instance
resource "aws_instance" "nhs_ec2" {
  ami             = var.ami
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.nhs_sg.name]
  tags = merge(local.common_tags, {
    Name = "NHS EC2 Instance"
  })
}

# Create a CloudWatch Log Group for monitoring
resource "aws_cloudwatch_log_group" "nhs_logs" {
  name              = "/aws/nhs/project"
  retention_in_days = 14
  tags              = merge(local.common_tags, { Name = "NHS CloudWatch Log Group" })
}
