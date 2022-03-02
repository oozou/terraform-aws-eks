output "endpoint" {
  value       = aws_eks_cluster.this.endpoint
  description = "cluster endpoint for EKS"
}

output "kubeconfig-certificate-authority-data" {
  value       = aws_eks_cluster.this.certificate_authority[0].data
  description = "kubeconfig certificate"
}

output "cluster_name" {
  value       = aws_eks_cluster.this.name
  description = "Name of the cluster"
}
