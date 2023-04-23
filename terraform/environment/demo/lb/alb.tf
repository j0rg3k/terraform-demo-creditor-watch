# Define Application Load Balancer

resource "aws_alb" "main" {
  name = "${var.nginx_app_name}-load-balancer"
  subnets = [data.terraform_remote_state.network.outputs.subnet_id]
  security_groups = [aws_security_group.aws-alb.id]
  load_balancer_type         = "application"
  internal                   = false
  enable_deletion_protection = true
  drop_invalid_header_fields = true
  tags = {
    Name = "${var.app_name}-alb"
  }
}
# Target group to port 80
resource "aws_alb_target_group" "nginx_app" {
  name = "${var.nginx_app_name}-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  target_type = "ip"
  health_check {
    healthy_threshold = "3"
    interval = "30"
    protocol = "HTTP"
    matcher = "200"
    timeout = "3"
    path = "/"
    unhealthy_threshold = "2"
  }

  tags = {
    Name = "${var.nginx_app_name}-alb-target-group"
  }
}

# create htttps listener
resource "aws_lb_listener" "alb_listener_https" {
  load_balancer_arn = aws_alb.main.id
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = data.terraform_remote_state.acm.outputs.acm_demo_arn
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  # Redirect all traffic from the ALB to the target group
  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.nginx_app.id
  }

  lifecycle {
    ignore_changes = [
      default_action
    ]
  }
}

# Redirect HTTP traffic to HTTPS
resource "aws_lb_listener" "redirect_http_to_https" {
  load_balancer_arn = aws_alb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
