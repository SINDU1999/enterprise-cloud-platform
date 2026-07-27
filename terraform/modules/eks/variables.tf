variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "project_code" {
  description = "Short project code"
  type        = string
}

variable "environment" {
  description = "Deployment Environment"
  type        = string
}

variable "cluster_role_arn" {
  description = "IAM Role ARN for the EKS Cluster"
  type        = string
}

variable "node_role_arn" {
  description = "IAM Role ARN for the EKS Worker Nodes"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "cluster_security_group_id" {
  description = "Security Group for EKS Cluster"
  type        = string
}
variable "node_instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
}

variable "disk_size" {
  description = "Disk size for worker nodes"
  type        = number
}