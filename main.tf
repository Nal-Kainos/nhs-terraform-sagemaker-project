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

locals {
  common_tags = {
    Project     = "NHS-Terraform-SageMaker"
    Environment = var.environment
  }
}

# Data source: Get the latest free-tier eligible Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Create a Security Group
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

# Deploy an EC2 instance using the data source for AMI
resource "aws_instance" "nhs_ec2" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.nhs_sg.name]
  tags            = merge(local.common_tags, { Name = "NHS EC2 Instance" })
}

# IAM Role for SageMaker
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
  tags = merge(local.common_tags, { Name = "NHS SageMaker Role" })
}

# Call the SageMaker module (we'll define this module in Step 4)
module "sagemaker" {
  source                = "./modules/sagemaker"
  name                  = "nhs-sagemaker"
  instance_type         = "ml.t2.medium"
  role_arn              = aws_iam_role.sagemaker_role.arn
  subnet_id             = var.subnet_id
  lifecycle_config_name = "nhs-lifecycle"
}

# Call the RDS module (we'll define this module in Step 4)
module "rds" {
  source             = "./modules/rds"
  name               = "nhs-postgres"
  db_username        = var.db_username
  db_password        = var.db_password
  security_group_ids = [aws_security_group.nhs_sg.id]
}
