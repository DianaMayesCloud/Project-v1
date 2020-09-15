#   This file creates: 
#       - 1 Scale Up Policies
#       - 2 CloudWatch Alarms
#            - one for CPU
#            - one for Memory 
#      


#****************************************** App Tier *************************************************

# Creates a Scale Up autoscaling policy to add one ec2 to Application Server
resource "aws_autoscaling_policy" "green_app_up_policy" {
  name                   = "green-app-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.green_app_asg.name
}

# Creates an alarm when CPU utilization in the Application Server goes above 75% AND Triggers the Scale Up autoscaling policy 
resource "aws_cloudwatch_metric_alarm" "app_cpu_alarm_scale_up" {
  alarm_name                = "app_cpu_alarm_up"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "75"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.green_app_asg.name
  }

  alarm_description = "To monitor EC2 instance CPU utilization in App Tier"
  alarm_actions     = [aws_autoscaling_policy.green_app_up_policy.arn]
}
# Creates an alarm when memory in the Application Server goes above 80% and Triggers the Scale Up autoscaling policy 
resource "aws_cloudwatch_metric_alarm" "app_memory_alarm_scale_up" {
  alarm_name          = "app_memory_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "mem_used_percent"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.green_app_asg.name
  }

  alarm_description = "To monitor EC2 instance Memory utilization"
  alarm_actions     = [aws_autoscaling_policy.green_app_up_policy.arn]
}

# This policy will be commented out as autoscaling gets triggered and keeps terminating and starting new ec2s
# Creates a Scale Down autoscaling policy to Terminate one ec2 in the Application Tier 
# resource "aws_autoscaling_policy" "green_app_down_policy" {
#   name                   = "green-app-down-policy"
#   scaling_adjustment     = -1
#   adjustment_type        = "ChangeInCapacity"
#   cooldown               = 300
#   autoscaling_group_name = aws_autoscaling_group.green_app_asg.name
# }
