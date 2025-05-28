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
         "modularization-test" = "true"
      }
    }
  }


  required_version = ">= 1.11.0"
}