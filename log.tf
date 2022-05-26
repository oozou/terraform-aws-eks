resource "aws_cloudwatch_log_group" "this" {
  name              = format("/aws/eks/%s-cluster/cluster", local.prefix)
  retention_in_days = var.cluster_log_retention_in_days
  tags              = local.tags
}
