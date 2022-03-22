resource "aws_eks_addon" "vpc-cni" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "vpc-cni"
}
