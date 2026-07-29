##############################################
# Private Hosted Zone
##############################################

resource "aws_route53_zone" "this" {
  count = var.create_private_zone ? 1 : 0

  name = local.hosted_zone_name

  vpc {
    vpc_id = var.vpc_id
  }

  tags = local.common_tags
}

##############################################
# DNS Record
##############################################

resource "aws_route53_record" "this" {
  zone_id = aws_route53_zone.this[0].zone_id

  name    = local.fqdn
  type    = var.record_type
  ttl     = var.record_ttl
  records = [var.record_value]
}