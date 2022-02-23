resource "aws_eks_cluster" "this" {
  name     = var.name
  role_arn = aws_iam_role.cluster_role.arn

  vpc_config {
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    subnet_ids              = var.subnets_ids
    security_group_ids      = [aws_security_group.eks_allow_tls.id]
  }
  version = var.eks_version
  tags = merge(
    {
      "Name" = "${var.name}-${var.environment}-cluster"
    },
    var.tags,
    local.default_tags
  )

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]
}

