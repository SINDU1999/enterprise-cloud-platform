variable "hosted_zone_name" {
  description = "Route53 Hosted Zone Name"
  type        = string
}

variable "record_name" {
  description = "DNS Record Name"
  type        = string
}

variable "alb_dns_name" {
  description = "Application Load Balancer DNS Name"
  type        = string
}

variable "alb_zone_id" {
  description = "Application Load Balancer Hosted Zone ID"
  type        = string
}