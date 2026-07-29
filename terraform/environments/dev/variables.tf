variable "aws_region" {
  description = "AWS Region for deployment"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "public_subnet_1_cidr" {
  description = "CIDR block for Public Subnet 1"
  type        = string
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for Public Subnet 2"
  type        = string
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for Private Subnet 1"
  type        = string
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for Private Subnet 2"
  type        = string
}

variable "availability_zone_1" {
  description = "Primary Availability Zone"
  type        = string
}

variable "availability_zone_2" {
  description = "Secondary Availability Zone"
  type        = string
}
variable "project_code" {
  description = "Short project code used for AWS resource names"
  type        = string
}
variable "node_instance_type" {
  type = string
}

variable "desired_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "disk_size" {
  type = number
}
####################################################
# KMS
####################################################

variable "key_alias" {
  description = "Alias for the KMS key"
  type        = string
}

####################################################
# Secrets Manager
####################################################

variable "secret_name" {
  description = "Secrets Manager secret name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_port" {
  description = "Database port"
  type        = number
}

####################################################
# RDS
####################################################

variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "engine_version" {
  description = "PostgreSQL engine version"
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
}

####################################################
# CloudWatch
####################################################

variable "log_group_name" {
  description = "CloudWatch Log Group name"
  type        = string
}

variable "alarm_name_prefix" {
  description = "CloudWatch alarm prefix"
  type        = string
}

variable "cpu_utilization_threshold" {
  description = "CPU utilization threshold"
  type        = number
}

variable "instance_id" {
  description = "EC2 Instance ID"
  type        = string
}

####################################################
# Route53
####################################################

variable "zone_name" {
  description = "Private hosted zone name"
  type        = string
}

variable "create_private_zone" {
  description = "Create private hosted zone"
  type        = bool
}

variable "record_name" {
  description = "DNS record name"
  type        = string
}

variable "record_type" {
  description = "DNS record type"
  type        = string
}

variable "record_ttl" {
  description = "DNS TTL"
  type        = number
}

variable "record_value" {
  description = "DNS record value"
  type        = string
}