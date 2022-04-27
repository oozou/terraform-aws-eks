output "endpoint" {
  value       = aws_eks_cluster.this.endpoint
  description = "cluster endpoint for EKS"
}

output "kubeconfig_certificate_authority_data" {
  value       = aws_eks_cluster.this.certificate_authority[0].data
  description = "kubeconfig certificate"
}

output "cluster_name" {
  value       = aws_eks_cluster.this.id
  description = "Name of the cluster"
}

# output "openid_connect_provider_arn" {
#   value       = aws_iam_openid_connect_provider.this.arn
#   description = "arn of oidc provider"
# }
