locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "CloudOps"
  }

  log_group_name = var.log_group_name

  cpu_alarm_name = "${var.alarm_name_prefix}-${var.environment}-cpu-utilization"
}