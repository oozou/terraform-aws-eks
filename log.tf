resource "aws_cloudwatch_log_group" "this" {
  name              = format("/aws/eks/%s-cluster/cluster", local.prefix)
  retention_in_days = var.cloudwatch_log_retention_in_days
  kms_key_id        = var.cloudwatch_log_kms_key_id

  tags = local.tags
}
