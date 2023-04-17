module "bootstrap" {
  count                    = var.is_create_bootstrap ? 1 : 0
  source                   = "./modules/bootstrap"
  subnet_id                = var.subnets_ids[0]
  cluster_name             = aws_eks_cluster.this.name
  ami                      = var.bootstrap_ami
  aws_account              = var.aws_account
  karpenter_node_role_arns = var.karpenter_node_role_arns
  admin_role_arns          = var.admin_role_arns
  admin_iam_arns           = var.admin_iam_arns
  dev_role_arns            = var.dev_role_arns
  readonly_role_arns       = var.readonly_role_arns
  node_group_role_arn      = aws_iam_role.node_group_role.arn
  vpc_id                   = var.vpc_id
  is_config_aws_auth       = var.is_config_aws_auth
  prefix                   = var.prefix
  environment              = var.environment
  kms_key_id               = var.bootstrap_kms_key_id
  tags                     = var.tags
}
