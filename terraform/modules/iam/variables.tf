variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "environment" {
  description = "Deployment Environment"
  type        = string
}
variable "project_code" {
  description = "Short project code used for AWS resource names"
  type        = string
}