resource "aws_eks_node_group" "this" {
  count           = length(var.node_groups)
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${local.prefix}-${var.node_groups[count.index].name}-nodegroup"
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = lookup(var.node_groups[count.index], "replace_subnets", var.subnets_ids)
  instance_types  = lookup(var.node_groups[count.index], "instance_types", ["t3.medium"])
  ami_type        = lookup(var.node_groups[count.index], "ami_type", "AL2_x86_64")
  capacity_type   = lookup(var.node_groups[count.index], "is_spot_instances", false) ? "SPOT" : "ON_DEMAND"
  disk_size       = lookup(var.node_groups[count.index], "disk_size", 20)
  labels          = lookup(var.node_groups[count.index], "labels", null)

  scaling_config {
    desired_size = lookup(var.node_groups[count.index], "desired_size", 1)
    max_size     = lookup(var.node_groups[count.index], "max_size", 1)
    min_size     = lookup(var.node_groups[count.index], "min_size", 1)
  }

  update_config {
    max_unavailable = lookup(var.node_groups[count.index], "max_unavailable", 1)
  }
  tags = merge(
    {
      "Name" = "${local.prefix}-${var.node_groups[count.index].name}-nodegroup"
    },
    local.tags
  )

  dynamic "taint" {
    for_each = var.node_groups[count.index].taint
    content {
      key    = taint.value.key
      value  = lookup(taint.value, "value", null)
      effect = taint.value.effect
    }
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size] # for support scaling
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_readonly,
  ]
}
