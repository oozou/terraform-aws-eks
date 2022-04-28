module "openid_connect" {
  source                               = "./modules/openid_connect_provider"
  prefix                               = var.prefix
  environment                          = var.environment
  tags                                 = local.tags
  cluster_oidc_issuer                  = aws_eks_cluster.this.identity[0].oidc[0].issuer
  is_create_loadbalancer_controller_sa = var.is_create_loadbalancer_controller_sa
  is_create_argo_image_updater_sa      = var.is_create_argo_image_updater_sa
  additional_service_accounts          = var.additional_service_accounts
  depends_on = [
    aws_eks_cluster.this
  ]
}
