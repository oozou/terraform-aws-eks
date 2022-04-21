resource "time_sleep" "delay_for_create_bootstrap" {
  create_duration = "5m"
  depends_on = [
    aws_eks_node_group.this
  ]
}

module "bootstrap" {
  source                      = "./modules/bootstrap"
  subnet_id                   = var.subnets_ids[0]
  cluster_name                = aws_eks_cluster.this.name
  aws_account                 = var.aws_account
  admin_role_arns             = var.admin_role_arns
  dev_role_arns               = var.dev_role_arns
  readonly_role_arns          = var.readonly_role_arns
  node_group_role_arn         = aws_iam_role.node_group_role.arn
  oidc_arn                    = aws_iam_openid_connect_provider.this.arn
  vpc_id                      = var.vpc_id
  is_config_aws_auth          = var.is_config_aws_auth
  is_config_aws_lb_controller = var.is_config_aws_lb_controller
  is_config_argo_cd           = var.is_config_argo_cd
  acm_arn                     = var.acm_arn
  argo_cd_domain              = var.argo_cd_domain
  prefix                      = var.prefix
  tags                        = var.tags
  is_config_ingress_nginx     = var.is_config_ingress_nginx
  environment                 = var.environment
  depends_on = [
    time_sleep.delay_for_create_bootstrap
  ]
}
