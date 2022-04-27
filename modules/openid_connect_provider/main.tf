resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.cluster.certificates[0].sha1_fingerprint]
  url             = var.cluster_oidc_issuer
  tags = merge(
    {
      "Name" = "${local.prefix}-eks-oidc-provider"
    },
    var.tags
  )
}
