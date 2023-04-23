variable "aws_region" {
  default = "ap-southeast-2"
}

# ECS cluster variables
variable "cluster_runner_type" {
  type = string
  description = "EC2 instance type of ECS Cluster Runner"
  default = "t3.small"
}
variable "cluster_runner_count" {
  type = string
  description = "Number of EC2 instances for ECS Cluster Runner"
  default = "1"
}

variable "aws_key_pair_name" {
  type = string
  description = "AWS key pair name"
}

variable "aws_key_pair_file" {
  type = string
  description = "Location of AWS key pair file"
}

# Application configuration
variable "app_name" {
  type = string
  description = "Application name"
  default = "demo"
}

variable "app_environment" {
  type = string
  description = "Application environment"
  default = "demo"
}

variable "admin_sources_cidr" {
  type = list(string)
  description = "List of IPv4 CIDR blocks from which to allow admin access"
  default = ["0.0.0.0/0"]
}

variable "app_sources_cidr" {
  type = list(string)
  description = "List of IPv4 CIDR blocks from which to allow application access"
  default = ["0.0.0.0/0"]
}
