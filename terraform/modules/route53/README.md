# Route53 Terraform Module

## Purpose

This module provisions Amazon Route 53 DNS resources for the Enterprise Cloud Platform.

## Resources

- Hosted Zone
- Alias Record
- ALB DNS Mapping

## Inputs

| Name | Description |
|------|-------------|
| hosted_zone_name | Hosted Zone Name |
| record_name | DNS Record Name |
| alb_dns_name | ALB DNS Name |
| alb_zone_id | ALB Hosted Zone ID |

## Outputs

- Hosted Zone ID
- Name Servers
- ALB Alias Record