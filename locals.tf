locals {
  prefix = "${var.prefix}-${var.environment}-${var.name}"
  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = "true"
    },
    var.tags,
  )
  cluster_encryption = toset(var.is_enabled_cluster_encryption ? [{
    provider_key_arn = module.eks_kms[0].key_arn
    resources        = ["secrets"]
  }] : [])
}
