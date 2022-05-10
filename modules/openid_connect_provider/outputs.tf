output "openid_connect_provider_arn" {
  value       = aws_iam_openid_connect_provider.this.arn
  description = "arn of oidc provider"
}

output "service_account_role_arns" {
  description = "created role arn for create service accounts in cluster"
  value       = aws_iam_role.aws_sa[*].arn
}
