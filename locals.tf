locals {
  prefix = "${var.name}-${var.environment}-${var.name}"
  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = "true"
    },
    var.tags,
  )
}