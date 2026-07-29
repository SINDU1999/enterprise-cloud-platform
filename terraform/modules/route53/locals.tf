locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "CloudOps"
  }

  hosted_zone_name = "${var.environment}.${var.zone_name}"

  fqdn = "${var.record_name}.${local.hosted_zone_name}"
}