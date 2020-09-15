# This file creates the following Resources for the Web Servers:
#   - Launch Template 
#   - Autoscaling Group 
#   - Target Group 
#   - Load Balancer 
#   - Listener
#   - Listener Rule
#

# Launch Template in Web Tier

resource "aws_launch_template" "green_web_template" {
  name                   = "green-web-tmpl"
  instance_type          = var.instance_type
  key_name               = var.key_name
  image_id               = data.aws_ami.linux-ami-id.id
  vpc_security_group_ids = [aws_security_group.green_priv1_sg.id]
  user_data              = base64encode(file("userdata.sh"))
  lifecycle {
    create_before_destroy = false
  }
  tags = {
    Name = "GoGreen Web Server"
  }
}

# Autoscaling Group for the Web Servers (links to Zones and Target Groups)
resource "aws_autoscaling_group" "green_web_asg" {
  vpc_zone_identifier       = [aws_subnet.priv1_az1_subnet.id, aws_subnet.priv1_az2_subnet.id]
  target_group_arns         = [aws_lb_target_group.green_web_tg.arn]
  name                      = "green-web-asg"
  max_size                  = "2"
  min_size                  = "1"
  desired_capacity          = "1"
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  launch_template {
    id      = aws_launch_template.green_web_template.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "green_web_asg"
    propagate_at_launch = "true"
  }

}

# Target Group -- web application tier (links to VPC)
resource "aws_lb_target_group" "green_web_tg" {
  name        = "green-web-tg"
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
    Name = "green_web_tg"
  }
}

# Internet Facing Application Load Balancer (links to subnets and security group)
resource "aws_lb" "green_web_alb" {
  name               = "green-web-alb"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.green_priv1_sg.id]
  subnets            = [aws_subnet.pub_az1_subnet.id, aws_subnet.pub_az2_subnet.id]
  tags = {
    Name = "green_web_alb"
  }
}

# Listener for Load Balancer (links to load balancer)
resource "aws_lb_listener" "green_web_listener" {
  load_balancer_arn = aws_lb.green_web_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green_web_tg.arn
  }
}

# Listener Rule for Listener (links to listener and target group)
resource "aws_lb_listener_rule" "green_web_listener_rule" {
  listener_arn = aws_lb_listener.green_web_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.green_web_tg.arn
  }
  condition {
    path_pattern {
      values = ["/static/*"]
    }
  }
}






