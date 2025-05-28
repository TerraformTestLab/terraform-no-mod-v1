# Required providers configuration
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
