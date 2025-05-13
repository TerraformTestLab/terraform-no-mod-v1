# Random string for unique naming
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Random pet for friendly resource naming
resource "random_pet" "instance" {
  length    = 2
  separator = "-"
}

# Data source
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Resource block
resource "aws_instance" "demo_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  monitoring    = var.enable_monitoring

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
  }

  tags = merge(local.common_tags, var.additional_tags, {
    Name = "demo-${random_pet.instance.id}"
  })
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
  vpc_cidr     = var.vpc_cidr
  environment  = var.environment
  common_tags  = merge(local.common_tags, var.additional_tags)
}

# GitHub module
module "s3_bucket" {
  source = "github.com/terraform-aws-modules/terraform-aws-s3-bucket?ref=v4.8.0"
  bucket = "demo-bucket-${local.resource_prefix}"
  tags = merge(local.common_tags, var.additional_tags)
  acl    = "private"
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  versioning = {
    enabled = true
  }
}

# Security Group with dynamic blocks
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "${local.resource_prefix}-sg"
  description = "Security group for demo instance"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    for port in var.allowed_ports : {
      from_port   = port
      to_port     = port
      protocol    = "tcp"
      description = "Port ${port}"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  tags = merge(local.common_tags, var.additional_tags)
}

# Data source for current region
data "aws_region" "current" {}
