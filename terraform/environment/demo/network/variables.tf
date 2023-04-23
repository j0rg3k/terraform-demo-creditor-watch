variable "aws_region" {
  default = "ap-southeast-2"
}

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