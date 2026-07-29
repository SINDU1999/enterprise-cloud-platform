variable "environment" {
  description = "Deployment environment"
  type        = string

  validation {
    condition     = contains(["dev", "qa", "prod"], var.environment)
    error_message = "Environment must be dev, qa or prod."
  }
}

variable "secret_name" {
  description = "Name of the Secrets Manager secret"
  type        = string
}

variable "description" {
  description = "Description of the secret"
  type        = string
  default     = "Enterprise application secret"
}

variable "kms_key_id" {
  description = "KMS Key ARN or ID used to encrypt the secret"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "postgres"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "enterprise_db"
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 5432
}