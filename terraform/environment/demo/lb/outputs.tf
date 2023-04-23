# output nginx public ip
output "nginx_dns_alb" {
  description = "DNS load balancer"
  value = aws_alb.main.dns_name
}

output "nginx_app_tg_id" {
  description = "load balancer target group nginx_app ID"
  value = aws_alb_target_group.nginx_app.id
}

output "alb_sg_aws_ecs_tasks_id" {
  description = "load balancer security group ID for ecs_tasks "
  value = aws_security_group.aws-ecs-tasks.id
}