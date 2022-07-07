resource "aws_secretsmanager_secret" "terraform_key" {
  name_prefix = format("%s-%s-test", var.prefix, var.environment)
  kms_key_id  = var.kms_key_id != "" ? var.kms_key_id : null
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "terraform_key" {
  secret_id = aws_secretsmanager_secret.terraform_key.id
  secret_string = jsonencode({
    aws_access_key_id     = var.aws_account.access_key
    aws_secret_access_key = var.aws_account.secret_key
  })
}

