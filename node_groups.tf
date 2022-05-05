resource "aws_eks_node_group" "this" {
  count           = length(var.node_groups)
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${local.prefix}-${var.node_groups[count.index].name}-nodegroup"
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = var.subnets_ids
  ami_type        = var.node_groups[count.index].ami_type
  instance_types  = var.node_groups[count.index].instance_types
  capacity_type   = var.node_groups[count.index].is_spot_instances ? "SPOT" : "ON_DEMAND"
  disk_size       = var.node_groups[count.index].disk_size
  labels          = var.node_groups[count.index].labels
  scaling_config {
    desired_size = var.node_groups[count.index].desired_size
    max_size     = var.node_groups[count.index].max_size
    min_size     = var.node_groups[count.index].min_size
  }

  update_config {
    max_unavailable = var.node_groups[count.index].max_unavailable
  }
  tags = merge(
    {
      "Name" = "${local.prefix}-${var.node_groups[count.index].name}-nodegroup"
    },
    local.tags
  )

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_readonly,
  ]
}
