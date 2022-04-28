resource "aws_eks_cluster" "this" {
  name     = "${local.prefix}-cluster"
  role_arn = aws_iam_role.cluster_role.arn

  vpc_config {
    endpoint_private_access = var.is_endpoint_private_access
    endpoint_public_access  = var.is_endpoint_public_access
    subnet_ids              = var.subnets_ids
    security_group_ids      = [aws_security_group.cluster.id]
  }
  version = var.eks_version
  tags = merge(
    {
      "Name" = "${local.prefix}-cluster"
    },
    local.tags
  )

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy,
    aws_iam_role_policy_attachment.amazon_eks_vpc_resource_controller,
  ]
}