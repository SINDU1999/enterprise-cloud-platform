variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "Environment must be dev, qa or prod."
  }
}

variable "key_alias" {
  description = "Alias for the KMS key"
  type        = string
}

variable "description" {
  description = "Description for the KMS key"
  type        = string
  default     = "Enterprise Cloud Platform KMS Key"
}

variable "enable_key_rotation" {
  description = "Enable automatic key rotation"
  type        = bool
  default     = true
}

variable "deletion_window_in_days" {
  description = "Waiting period before key deletion"
  type        = number
  default     = 30
}