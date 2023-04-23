# Create AWS Certificate for ALB
resource "aws_acm_certificate" "demo" {
  domain_name       = "demo.com"
  validation_method = "DNS"

  tags = {
    Environment = "demo"
  }

  lifecycle {
    create_before_destroy = true
  }
}