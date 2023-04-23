# Define ALB Security Group
# nginx security

resource "aws_security_group" "aws-alb" {
  name = "${var.nginx_app_name}-load-balancer"
  description = "Controls access to the ALB"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id

  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.nginx_app_name}-load-balancer"
  }
}

resource "aws_security_group_rule" "alb-allow-http" {
  type              = "ingress"
  from_port = var.nginx_app_port
  to_port = var.nginx_app_port
  cidr_blocks = var.app_sources_cidr
  protocol          = "tcp"
  security_group_id = aws_security_group.aws-alb.id
}

resource "aws_security_group_rule" "alb-allow-https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.app_sources_cidr
  security_group_id = aws_security_group.aws-alb.id
}

# Traffic to the ECS cluster from the ALB
resource "aws_security_group" "aws-ecs-tasks" {
  name = "${var.nginx_app_name}-ecs-tasks"
  description = "Allow inbound access from the ALB only"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  ingress {
    protocol = "tcp"
    from_port = var.nginx_app_port
    to_port = var.nginx_app_port
    security_groups = [aws_security_group.aws-alb.id]
  }
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.nginx_app_name}-ecs-tasks"
  }
}



