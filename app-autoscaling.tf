# This file creates the following Resources for the Application Servers:
#   - Launch Template 
#   - Autoscaling Group 
#   - Target Group 
#   - Load Balancer 
#   - Listener
#   - Listener Rule
#

# Launch Template in App Tier

resource "aws_launch_template" "green_app_template" {
  name                   = "green-app-tmpl"
  instance_type          = var.instance_type
  key_name               = var.key_name
  image_id               = data.aws_ami.linux-ami-id.id
  vpc_security_group_ids = [aws_security_group.green_priv2_sg.id]
  user_data              = base64encode(file("app_userdata.sh"))
  lifecycle {
    create_before_destroy = false
  }
  tags = {
    Name = "GoGreen App Server"
  }
}

# Autoscaling Group for the App Servers (links to Zones and Target Groups)
resource "aws_autoscaling_group" "green_app_asg" {
  vpc_zone_identifier       = [aws_subnet.priv1_az1_subnet.id, aws_subnet.priv1_az2_subnet.id]
  target_group_arns         = [aws_lb_target_group.green_app_tg.arn]
  name                      = "green-app-asg"
  max_size                  = "2"
  min_size                  = "1"
  desired_capacity          = "1"
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  launch_template {
    id      = aws_launch_template.green_app_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "green_app_asg"
    propagate_at_launch = "true"
  }

}

# Target Group -- App application tier (links to VPC)
resource "aws_lb_target_group" "green_app_tg" {
  name        = "green-app-tg"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.green_vpc.id
  health_check {
    port                = 80
    path                = "/"
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 7
    interval            = 10
  }
  tags = {
    Name = "green_app_tg"
  }
}

# Internal Application Load Balancer (links to subnets and security group)
resource "aws_lb" "green_app_alb" {
  name               = "green-app-alb"
  internal           = true
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.green_priv2_sg.id]
  subnets            = [aws_subnet.priv1_az1_subnet.id, aws_subnet.priv1_az2_subnet.id]
  tags = {
    Name = "green_app_alb"
  }
}

# Listener for Load Balancer (links to load balancer)
resource "aws_lb_listener" "green_app_listener" {
  load_balancer_arn = aws_lb.green_app_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green_app_tg.arn
  }
}

# Listener Rule for Listener (links to listener and target group)
resource "aws_lb_listener_rule" "green_app_listener_rule" {
  listener_arn = aws_lb_listener.green_app_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green_app_tg.arn
  }
  condition {
    path_pattern {
      values = ["/static/*"]
    }
  }
}






