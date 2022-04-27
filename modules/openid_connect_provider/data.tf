data "tls_certificate" "cluster" {
  url = var.cluster_oidc_issuer
}
