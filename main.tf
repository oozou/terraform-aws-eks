resource "aws_eks_cluster" "this" {
  name     = "${local.prefix}-cluster"
  role_arn = aws_iam_role.cluster_role.arn

  vpc_config {
    endpoint_private_access = var.is_endpoint_private_access
    endpoint_public_access  = var.is_endpoint_public_access
    subnet_ids              = var.subnets_ids
    security_group_ids      = [aws_security_group.cluster.id]
  }

  enabled_cluster_log_types = var.enabled_cluster_log_types
  dynamic "encryption_config" {
    for_each = local.cluster_encryption

    content {
      provider {
        key_arn = encryption_config.value.provider_key_arn
      }
      resources = encryption_config.value.resources
    }
  }
  version = var.eks_version
  tags = merge(
    {
      "Name" = "${local.prefix}-cluster"
    },
    local.tags
  )
  tags_all = {
    tags_all = true
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy,
    aws_iam_role_policy_attachment.amazon_eks_vpc_resource_controller,
    aws_cloudwatch_log_group.this
  ]
}
