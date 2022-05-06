resource "aws_eks_addon" "vpc_cni" {
  count        = length(var.additional_addons)
  cluster_name = aws_eks_cluster.this.name
  addon_name   = var.additional_addons[count.index]
}
