variable "vpc_id" {
  description = "VPC ID where Security Groups will be created"
  type        = string
}

variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "environment" {
  description = "Deployment Environment"
  type        = string
}