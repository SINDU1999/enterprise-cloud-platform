# Route53 Module

## Overview

This module provisions Route53 DNS resources for the Enterprise Cloud Platform.

## Features

- Private Hosted Zone
- VPC Association
- DNS Record Creation
- Reusable variables
- Standard tagging

## Resources

- aws_route53_zone
- aws_route53_record

## Inputs

- project_name
- environment
- zone_name
- vpc_id
- create_private_zone
- record_name
- record_type
- record_ttl
- record_value

## Outputs

- Hosted Zone ID
- Hosted Zone Name
- Record FQDN
- Name Servers