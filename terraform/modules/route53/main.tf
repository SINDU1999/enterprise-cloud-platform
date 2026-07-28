resource "aws_route53_zone" "this" {
  name = var.hosted_zone_name

  tags = {
    Name        = "enterprise-route53-zone"
    Environment = "dev"
    Project     = "enterprise-cloud-platform"
  }
}

resource "aws_route53_record" "alb_alias" {
  zone_id = aws_route53_zone.this.zone_id
  name    = var.record_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}