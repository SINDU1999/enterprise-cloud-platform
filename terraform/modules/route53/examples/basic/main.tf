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

module "route53" {
  source = "../../"

  project_name = "enterprise-cloud-platform"
  environment  = "dev"

  # This will create the private hosted zone:
  # dev.enterprise.internal
  zone_name = "enterprise.internal"

  # Your VPC
  vpc_id = "vpc-04c3b20c2b8137d1c"

  # Create a Private Hosted Zone
  create_private_zone = true

  # DNS Record
  record_name = "api"
  record_type = "A"
  record_ttl  = 300

  # Private IP address of your EC2 instance
  record_value = "172.31.8.82"
}