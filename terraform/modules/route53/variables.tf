variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "zone_name" {
  description = "Route53 hosted zone name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for Private Hosted Zone"
  type        = string
}

variable "create_private_zone" {
  description = "Whether to create a private hosted zone"
  type        = bool
  default     = true
}

variable "record_name" {
  description = "DNS record name"
  type        = string
}

variable "record_type" {
  description = "DNS record type"
  type        = string
  default     = "A"
}

variable "record_ttl" {
  description = "DNS record TTL"
  type        = number
  default     = 300
}

variable "record_value" {
  description = "DNS record value"
  type        = string
}