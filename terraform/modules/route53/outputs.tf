output "hosted_zone_id" {
  value = aws_route53_zone.this.zone_id
}

output "hosted_zone_name_servers" {
  value = aws_route53_zone.this.name_servers
}

output "alb_dns_record" {
  value = aws_route53_record.alb_alias.fqdn
}