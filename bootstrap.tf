module "bootstrap" {
  source            = "./modules/bootstrap"
  subnet_id         = "subnet-0b7099c09bc9e7ab2" #var.subnets_ids[0]
  cluster_name      = aws_eks_cluster.this.name
  aws_account       = var.aws_account
  admin_role_arn    = var.admin_role_arn
  dev_role_arn      = var.dev_role_arn
  readonly_role_arn = var.readonly_role_arn
  tags = merge(
    {
      "Name" = "${var.name}-${var.environment}-bootstrap"
    },
    var.tags,
    local.default_tags
  )
  node_group_role_arns = aws_eks_node_group.this[*].arn
}