terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  cloud {
    organization = "sujay-test-01"
    workspaces {
      tags = {
        github-repo = "terraform-no-mod-v1"
      }
    }
  }


  required_version = ">= 1.11.0"
}

provider "aws" {
  region = var.aws_region
}

provider "random" {}

# Local variables
locals {
  common_tags = {
    Environment = var.environment
    Project     = "terraform-no-mod-v1"
    ManagedBy   = "Terraform"
    CanDelete   = "true"
    Category    = "demo"
  }
  resource_prefix = "${var.environment}-${random_string.suffix.result}"
}
