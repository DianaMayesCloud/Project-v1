#   This file creates: 
#       - 1 Scale Up Policy
#       - 2 CloudWatch Alarms 
#           - one for CPU
#           - one for Memory 
#      

#********************************* Web Tier ********************************************

# Creates a Scale Up autoscaling policy to add one ec2 to Web Server
resource "aws_autoscaling_policy" "green_web_up_policy" {
  name                   = "green-web-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.green_web_asg.name
}

# Creates an alarm when CPU utilization in the Web Server goes above 75% AND Triggers the Scale Up autoscaling policy 
resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_scale_up" {
  alarm_name                = "web_cpu_alarm_up"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "75"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.green_web_asg.name
  }

  alarm_description = "To monitor EC2 instance CPU utilization in Web Tier"
  alarm_actions     = [aws_autoscaling_policy.green_web_up_policy.arn]
}

# Creates an alarm when the memory in the Web Server goes above 55% and Triggers the Scale Up autoscaling policy 
resource "aws_cloudwatch_metric_alarm" "web_memory_alarm_scale_up" {
  alarm_name          = "web_memory_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "mem_used_percent"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "55"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.green_web_asg.name
  }

  alarm_description = "To monitor EC2 instance Memory utilization"
  alarm_actions     = [aws_autoscaling_policy.green_web_up_policy.arn]
}



