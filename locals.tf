locals {
  default_tags = {
    "Environment" = var.environment,
    "Terraform"   = "true"
  }
}