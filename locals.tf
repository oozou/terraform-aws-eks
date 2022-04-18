locals {
  prefix = "${var.prefix}-${var.environment}-${var.name}"
  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = "true"
    },
    var.tags,
  )
}
