variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "log_group_name" {
  description = "CloudWatch Log Group name"
  type        = string
}

variable "log_retention_days" {
  description = "Retention period for log groups"
  type        = number
  default     = 30
}


variable "alarm_name_prefix" {
  description = "Prefix for CloudWatch alarms"
  type        = string
  default     = "enterprise"
}

variable "cpu_utilization_threshold" {
  description = "CPU utilization threshold for alarms"
  type        = number
  default     = 80
}
variable "instance_id" {
  description = "EC2 Instance ID to monitor"
  type        = string
}