module "openid_connect" {
  source              = "./modules/openid_connect_provider"
  prefix              = var.prefix
  environment         = var.environment
  tags                = local.tags
  cluster_oidc_issuer = aws_eks_cluster.this.identity[0].oidc[0].issuer
  depends_on = [
    aws_eks_cluster.this
  ]
}
