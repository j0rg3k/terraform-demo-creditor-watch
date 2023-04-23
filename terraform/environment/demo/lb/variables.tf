variable "aws_region" {
  default = "ap-southeast-2"
}

variable "nginx_app_name" {
  description = "Name of Application Container"
  default = "nginx"
}

variable "nginx_app_port" {
  description = "Port exposed by the Docker image to redirect traffic to"
  default = 80
}

variable "app_name" {
  type = string
  description = "Application name"
  default = "demo"
}

variable "app_sources_cidr" {
  type = list(string)
  description = "List of IPv4 CIDR blocks from which to allow application access"
  default = ["0.0.0.0/0"]
}