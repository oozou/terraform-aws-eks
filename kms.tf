module "eks_kms" {
  count = var.is_enabled_cluster_encryption ? 1 : 0

  source      = "git@github.com:oozou/terraform-aws-kms-key.git?ref=v0.0.2"
  key_type    = "service"
  description = "Used to encrypt data for eks secret"
  prefix      = var.prefix
  name        = format("%s-eks", local.prefix)
  environment = var.environment
  tags        = var.tags
}
