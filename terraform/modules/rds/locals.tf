locals {
  common_tags = {
    Project     = "enterprise-cloud-platform"
    ManagedBy   = "Terraform"
    Owner       = "CloudOps"
    Environment = var.environment
  }
}