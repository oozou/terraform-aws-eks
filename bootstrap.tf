module "bootstrap" {
  source              = "./modules/bootstrap"
  subnet_id           = var.subnets_ids[0]
  cluster_name        = aws_eks_cluster.this.name
  aws_account         = var.aws_account
  admin_role_arns     = var.admin_role_arns
  dev_role_arns       = var.dev_role_arns
  readonly_role_arns  = var.readonly_role_arns
  node_group_role_arn = aws_iam_role.node_group_role.arn
  vpc_id              = var.vpc_id
  is_config_aws_auth  = var.is_config_aws_auth
  prefix              = var.prefix
  tags                = var.tags
  environment         = var.environment
  depends_on = [
    aws_eks_node_group.this
  ]
}
