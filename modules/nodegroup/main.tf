resource "aws_eks_node_group" "this" {
  cluster_name    = var.cluster_name
  node_group_name = format("%s-%s-nodegroup", local.prefix, var.name)
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids
  instance_types  = var.instance_types
  ami_type        = var.ami_type
  capacity_type   = var.is_spot_instances ? "SPOT" : "ON_DEMAND"
  disk_size       = var.disk_size
  labels          = var.labels

  dynamic "launch_template" {
    for_each = var.is_create_launch_template ? [1] : []
    content {
      id    = aws_launch_template.this[0].id
      version = "$Default"
    }
  }

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = var.max_unavailable
  }
  tags = merge(
    {
      "Name" = format("%s-%s-nodegroup", local.prefix, var.name)
    },
    var.tags
  )

  dynamic "taint" {
    for_each = var.taint
    content {
      key    = taint.value.key
      value  = lookup(taint.value, "value", null)
      effect = taint.value.effect
    }
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size] # for support scaling
  }
}
