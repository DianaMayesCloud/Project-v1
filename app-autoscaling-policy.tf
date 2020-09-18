#   This file creates: 
#       - 1 Scale Up Policy
#       - 1 Scale Down Policy
#       - 3 CloudWatch Alarms
#            - one for CPU when CPU goes above threshold 
#            - one for Memory when Memory goes above threshold
#            - one for Memory when Memory goes below threshold             
#      

#****************************************** Scale Up  *************************************************

# Creates a Scale Up autoscaling policy to add one ec2 to Application Server
resource "aws_autoscaling_policy" "green_app_up_policy" {
  name                   = "green-app-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.green_app_asg.name
}

# Creates an alarm when CPU utilization in the Application Server goes above 75% AND Triggers the Scale Up autoscaling policy 
resource "aws_cloudwatch_metric_alarm" "app_cpu_alarm_scale_down" {
  alarm_name          = "app-cpu-alarm-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "75"
  #actions_enabled     = true
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.green_app_asg.name
  }

  alarm_description = "To monitor EC2 instance CPU utilization in App Tier"
  alarm_actions     = [aws_autoscaling_policy.green_app_up_policy.arn]
}
# Creates an alarm when memory in the Application Server goes above 80% and Triggers the Scale Up autoscaling policy 
# resource "aws_cloudwatch_metric_alarm" "app_memory_alarm_scale_up" {
#   alarm_name          = "app-memory-alarm-up"
#   comparison_operator = "GreaterThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "mem_used_percent"
#   namespace           = "AWS/EC2"
#   period              = "120"
#   statistic           = "Average"
#   threshold           = "80"

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.green_app_asg.name
#   }

#   alarm_description = "To monitor EC2 instance Memory utilization"
#   alarm_actions     = [aws_autoscaling_policy.green_app_up_policy.arn]
# }

# #*************************************************  SCALE DOWN POLICY **************************************************************


# Scale Down autoscaling policy to Terminate one ec2 in the Application Tier 
resource "aws_autoscaling_policy" "green_app_down_policy" {
  name                   = "green-app-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.green_app_asg.name
}

# Alarm when CPU utilization in the App Server goes below 30% AND Triggers the Scale Down autoscaling policy 
resource "aws_cloudwatch_metric_alarm" "app_cpu_alarm_scale_up" {
  alarm_name          = "app-cpu-alarm-up"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"
  #actions_enabled     = true
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.green_app_asg.name
  }

  alarm_description = "To monitor EC2 instance CPU utilization in Web Tier"
  alarm_actions     = [aws_autoscaling_policy.green_web_down_policy.arn]
}

# # Alarm when memory in the Application Server goes below 30% and Triggers the Scale Down autoscaling policy 
# resource "aws_cloudwatch_metric_alarm" "app_memory_alarm_scale_down" {
#   alarm_name          = "app-memory-alarm-down"
#   comparison_operator = "LessThanOrEqualToThreshold"
#   evaluation_periods  = "2"
#   metric_name         = "mem_used_percent"
#   namespace           = "AWS/EC2"
#   period              = "120"
#   statistic           = "Average"
#   threshold           = "30"

#   dimensions = {
#     AutoScalingGroupName = aws_autoscaling_group.green_app_asg.name
#   }

#   alarm_description = "To monitor EC2 instance Memory level"
#   alarm_actions     = [aws_autoscaling_policy.green_app_down_policy.arn]
# }
