data "aws_vpc" "this" {
  id = var.vpc_id
}

data "tls_certificate" "cluster" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}
