# CloudWatch Module

## Overview

This module provisions CloudWatch resources for the Enterprise Cloud Platform.

## Features

- CloudWatch Log Group
- CloudWatch CPU Alarm
- KMS encryption for Log Groups
- Configurable log retention
- Reusable tagging strategy

## Resources Created

- aws_cloudwatch_log_group
- aws_cloudwatch_metric_alarm

## Inputs

| Name | Description |
|------|-------------|
| project_name | Project name |
| environment | Deployment environment |
| log_group_name | Log group name |
| log_retention_days | Log retention period |
| kms_key_id | KMS Key ARN |
| cpu_utilization_threshold | CPU alarm threshold |

## Outputs

- Log Group Name
- Log Group ARN
- CPU Alarm Name
- CPU Alarm ARN