provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "FinCore Enterprise Cloud Platform"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}