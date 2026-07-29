output "log_group_name" {
  description = "CloudWatch Log Group name"
  value       = aws_cloudwatch_log_group.this.name
}

output "log_group_arn" {
  description = "CloudWatch Log Group ARN"
  value       = aws_cloudwatch_log_group.this.arn
}

output "cpu_alarm_name" {
  description = "CPU alarm name"
  value       = aws_cloudwatch_metric_alarm.cpu_utilization.alarm_name
}

output "cpu_alarm_arn" {
  description = "CPU alarm ARN"
  value       = aws_cloudwatch_metric_alarm.cpu_utilization.arn
}