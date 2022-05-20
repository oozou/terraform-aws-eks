resource "aws_eks_node_group" "this" {
  for_each        = var.node_groups
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${local.prefix}-${each.key}-nodegroup"
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = lookup(each.value, "replace_subnets", var.subnets_ids)
  instance_types  = lookup(each.value, "instance_types", ["t3.medium"])
  ami_type        = lookup(each.value, "ami_type", "AL2_x86_64")
  capacity_type   = lookup(each.value, "is_spot_instances", false) ? "SPOT" : "ON_DEMAND"
  disk_size       = lookup(each.value, "disk_size", 20)
  labels          = lookup(each.value, "labels", null)

  scaling_config {
    desired_size = lookup(each.value, "desired_size", 1)
    max_size     = lookup(each.value, "max_size", 1)
    min_size     = lookup(each.value, "min_size", 1)
  }

  update_config {
    max_unavailable = lookup(each.value, "max_unavailable", 1)
  }
  tags = merge(
    {
      "Name" = "${local.prefix}-${each.key}-nodegroup"
    },
    local.tags
  )

  dynamic "taint" {
    for_each = lookup(each.value, "taint", {})
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
