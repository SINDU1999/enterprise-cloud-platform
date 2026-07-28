terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "rds" {
  source = "../../"

  # General
  environment = "dev"

  # Database
  db_identifier     = "enterprise-postgres"
  db_name           = "enterprise_db"
  instance_class    = "db.t3.micro"
  engine_version    = "17.5"
  allocated_storage = 20

  # Existing KMS Key
  kms_key_id = "arn:aws:kms:ap-south-1:908209635299:key/a12ae3fa-7a8a-4dc3-ae67-55259082d641"

  # Existing Secrets Manager Secret
  secret_arn = "arn:aws:secretsmanager:ap-south-1:908209635299:secret:enterprise-db-x79lQM"

  # Existing Private Subnets
  subnet_ids = [
    "subnet-0e174108b1e7cb695",
    "subnet-00ee8ed69d190224d"
  ]

  # Existing EKS Node Security Group
  security_group_ids = [
    "sg-01f9d5838a038cc33"
  ]
}