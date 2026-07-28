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

module "cloudwatch" {
  source = "../../"

  project_name = "enterprise-cloud-platform"
  environment  = "dev"

  log_group_name     = "application-logs"
  log_retention_days = 30

  kms_key_id = "arn:aws:kms:ap-south-1:908209635299:key/a12ae3fa-7a8a-4dc3-ae67-55259082d641"

  alarm_name_prefix         = "enterprise"
  cpu_utilization_threshold = 80
  instance_id               = "i-0e6ff9e566c3a3948"
}