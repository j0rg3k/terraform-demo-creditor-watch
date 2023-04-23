# output acm
output "acm_demo_arn" {
  description = "ARN of demo certificate"
  value = aws_acm_certificate.demo.arn
}