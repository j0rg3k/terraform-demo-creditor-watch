# network outputs
output "vpc_id" {
  description = "VPC ID"
  value = aws_vpc.vpc.id
}

output "subnet_id" {
  description = "list of subnets ID"
  value = aws_subnet.aws-subnet.*.id
}