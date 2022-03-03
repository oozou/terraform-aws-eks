resource "aws_security_group" "cluster" {
  name        = "${local.prefix}-eks-cluster-sg"
  description = "EKS security group for controll access to cluster api"
  vpc_id      = var.vpc_id
  tags = merge(
    {
      "Name" = "${local.prefix}-eks-cluster-sg"
    },
    local.tags
  )
}

resource "aws_security_group_rule" "eks_ingress_allow_tls" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = concat([data.aws_vpc.this.cidr_block], var.additional_allow_cidr)
  security_group_id = aws_security_group.cluster.id
}

resource "aws_security_group_rule" "eks_egress_allow_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cluster.id
}