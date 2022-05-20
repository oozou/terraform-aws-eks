resource "aws_eks_addon" "this" {
  for_each                 = var.additional_addons
  cluster_name             = aws_eks_cluster.this.name
  addon_name               = lookup(each.value, "name", null)
  addon_version            = lookup(each.value, "version", null)
  resolve_conflicts        = lookup(each.value, "resolve_conflicts", null)
  service_account_role_arn = lookup(each.value, "service_account_role_arn", null)
  tags                     = local.tags
}
