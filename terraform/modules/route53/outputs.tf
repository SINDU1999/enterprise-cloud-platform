output "hosted_zone_id" {
  description = "Route53 Hosted Zone ID"
  value       = aws_route53_zone.this[0].zone_id
}

output "hosted_zone_name" {
  description = "Route53 Hosted Zone Name"
  value       = aws_route53_zone.this[0].name
}

output "record_fqdn" {
  description = "Fully Qualified Domain Name"
  value       = aws_route53_record.this.fqdn
}

output "name_servers" {
  description = "Hosted Zone Name Servers"
  value       = try(aws_route53_zone.this[0].name_servers, [])
}