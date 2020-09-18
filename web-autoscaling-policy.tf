#   This file creates: 
#       - 1 Scale Up Policy
#       - 1 Scale Down Policy
#       - 2 CloudWatch Alarms
#            - one for CPU when CPU goes above threshold 
#            - one for Memory when Memory goes above threshold
#            - one for Memory when Memory goes below threshold   
#      
#********************************* SCALE UP POLiCY and CLOUDWATCH ALARM ********************************************

# Creates a Scale Up autoscaling policy to add one ec2 to Web Server
resource "aws_autoscaling_policy" "green_web_up_policy" {
  name                   = "green-web-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.green_web_asg.name
  policy_type            = "SimpleScaling"
}

# Alarm when CPU utilization in the Web Server goes above 75% AND Triggers the Scale Up autoscaling policy 
resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_scale_up" {
  alarm_name          = "web-cpu-alarm-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "60"
  #actions_enabled     = true
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.green_web_asg.name
  }

  alarm_description = "To monitor EC2 instance CPU utilization in Web Tier"
  alarm_actions     = [aws_autoscaling_policy.green_web_up_policy.arn]
}
# Alarm when memory in the Application Server goes above 80% and Triggers the Scale Up autoscaling policy 
# resource "aws_cloudwatch_metric_alarm" "web_memory_alarm_scale_up" {
#   alarm_name          = "web-memory-alarm-up"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "mem_used_percent"
#   namespace           = "AWS/EC2"
#   period              = "120"
#   statistic           = "Average"
#   threshold           = "60"

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.green_web_asg.name
#   }

#   alarm_description = "To monitor EC2 instance Memory utilization"
#   alarm_actions     = [aws_autoscaling_policy.green_web_up_policy.arn]
# }

# *************************************************  SCALE DOWN POLICY **************************************************************

# Creates a Scale Down autoscaling policy to terminate one ec2 to Web Server
resource "aws_autoscaling_policy" "green_web_down_policy" {
  name                   = "green-web-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.green_web_asg.name
}

# Alarm when CPU utilization in the Web Server goes below 30% AND Triggers the Scale Down autoscaling policy 
resource "aws_cloudwatch_metric_alarm" "web_cpu_alarm_scale_down" {
  alarm_name          = "web-cpu-alarm-up"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  #actions_enabled     = true
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.green_web_asg.name
  }

  alarm_description = "To monitor EC2 instance CPU utilization in Web Tier"
  alarm_actions     = [aws_autoscaling_policy.green_web_down_policy.arn]
}
# # Alarm when memory in the Web Server goes above 30% and Triggers the Scale Up autoscaling policy 
# resource "aws_cloudwatch_metric_alarm" "web_memory_alarm_scale_down" {
#   alarm_name          = "web-memory-alarm-down"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "mem_used_percent"
#   namespace           = "AWS/EC2"
#   period              = "120"
#   statistic           = "Average"
#   threshold           = "30"

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.green_web_asg.name
#   }

#   alarm_description = "To monitor EC2 instance Memory utilization"
#   alarm_actions     = [aws_autoscaling_policy.green_web_down_policy.arn]
# }

