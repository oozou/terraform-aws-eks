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

output "kms_key_arn" {
  description = "EKS encryption KMS key arn"
  value       = try(module.eks_kms[0].key_arn, "")
}

output "kms_key_id" {
  description = "EKS encryption KMS key id"
  value       = try(module.eks_kms[0].key_id, "")
}

output "cluster_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster for control-plane-to-data-plane communication."
  value       = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
}

output "cloudwatch_log_group_arn" {
  description = "arn of cluster cloudwatch log group"
  value       = aws_cloudwatch_log_group.this.arn
}

output "openid_connect_provider_arn" {
  value       = try(module.openid_connect[0].openid_connect_provider_arn, "")
  description = "arn of oidc provider"
}

output "service_account_role_arns" {
  description = "created role arn for create service accounts in cluster"
  value       = try(module.openid_connect[0].service_account_role_arns, "")
}
