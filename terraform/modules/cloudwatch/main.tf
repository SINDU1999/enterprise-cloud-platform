##############################################
# CloudWatch Log Group
##############################################

resource "aws_cloudwatch_log_group" "this" {
  name              = local.log_group_name
  retention_in_days = var.log_retention_days
  

  tags = local.common_tags
}

##############################################
# CloudWatch CPU Alarm
##############################################

resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  alarm_name          = local.cpu_alarm_name
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.cpu_utilization_threshold
   dimensions = {
  InstanceId = var.instance_id
}

  alarm_description = "Alarm when CPU utilization exceeds threshold"

  treat_missing_data = "notBreaching"

  tags = local.common_tags
 
}