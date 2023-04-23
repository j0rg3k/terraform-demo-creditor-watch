# define & build the ecs cluster

# create ecs cluster
resource "aws_ecs_cluster" "aws-ecs" {
  name = var.app_name
}

# get latest ecs ami
data "aws_ami" "ecs-ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["amzn2-ami-ecs-hvm-2.0.*"]
  }
  filter {
    name = "architecture"
    values = ["x86_64"]
  }
  owners = ["amazon"]
}

locals {
  aws_ecs_ami = data.aws_ami.ecs-ami.id
}

# ecs cluster runner role policies
resource "aws_iam_role" "ecs-cluster-runner-role" {
  name = "${var.app_name}-cluster-runner-role"
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role.json
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ecs-cluster-runner-policy" {
  statement {
    actions = ["ec2:Describe*", "ecr:Describe*", "ecr:BatchGet*"]
    resources = ["*"]
  }
  statement {
    actions = ["ecs:*"]
    resources = ["arn:aws:ecs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:service/${var.app_name}/*"]
  }
}

resource "aws_iam_role_policy" "ecs-cluster-runner-role-policy" {
  name = "${var.app_name}-cluster-runner-policy"
  role = aws_iam_role.ecs-cluster-runner-role.name
  policy = data.aws_iam_policy_document.ecs-cluster-runner-policy.json
}

resource "aws_iam_instance_profile" "ecs-cluster-runner-profile" {
  name = "${var.app_name}-cluster-runner-iam-profile"
  role = aws_iam_role.ecs-cluster-runner-role.name
}

# ec2 user data for volume
data "template_file" "user_data_cluster" {
  template = file("user_data.sh")
  vars = {
    ecs_cluster = aws_ecs_cluster.aws-ecs.name
  }
}

# create ec2 instance for the ecs cluster runner
resource "aws_instance" "ecs-cluster-runner" {
  ami = local.aws_ecs_ami
  instance_type = var.cluster_runner_type
  subnet_id = data.terraform_remote_state.network.outputs.subnet_id
  vpc_security_group_ids = [aws_security_group.ecs-cluster-host.id]
  associate_public_ip_address = true
  key_name = var.aws_key_pair_name
  user_data = data.template_file.user_data_cluster.rendered
  count = var.cluster_runner_count
  iam_instance_profile = aws_iam_instance_profile.ecs-cluster-runner-profile.name
  tags = {
    Name = "${var.app_name}-ecs-cluster-runner"
    Environment = var.app_environment
    Role = "ecs-cluster"
  }
  volume_tags = {
    Name = "${var.app_name}-ecs-cluster-runner"
    Environment = var.app_environment
    Role = "ecs-cluster"
  }
}

# create security group and segurity rules for the ecs cluster
resource "aws_security_group" "ecs-cluster-host" {
  name = "${var.app_name}-ecs-cluster-host"
  description = "${var.app_name}-ecs-cluster-host"
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  tags = {
    Name = "${var.app_name}-ecs-cluster-host"
    Environment = var.app_environment
    Role = "ecs-cluster"
  }
}

resource "aws_security_group_rule" "ecs-cluster-host-ssh" {
  security_group_id = aws_security_group.ecs-cluster-host.id
  description = "admin SSH access to ecs cluster"
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = var.admin_sources_cidr
}

resource "aws_security_group_rule" "ecs-cluster-egress" {
  security_group_id = aws_security_group.ecs-cluster-host.id
  description = "ecs cluster egress"
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}