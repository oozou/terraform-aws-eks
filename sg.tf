resource "aws_security_group" "eks_allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.vpc_id
  tags = merge(
    {
      "Name" = "${var.name}-${var.environment}-cluster-allow-tls"
    },
    var.tags,
    local.default_tags
  )
}

resource "aws_security_group_rule" "eks_ingress_allow_tls" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [data.aws_vpc.this.cidr_block]
  security_group_id = aws_security_group.eks_allow_tls.id
}

resource "aws_security_group_rule" "eks_egress_allow_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.eks_allow_tls.id
}