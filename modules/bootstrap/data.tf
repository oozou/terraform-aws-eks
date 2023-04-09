data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "eks_manifest" {
  template = file("${path.module}/templates/eks-manifest-file.yml")
  vars = {
    node_group_role_arn   = var.node_group_role_arn
    admin_role_arns       = <<EOT
%{for i, arn in var.admin_role_arns~}
    - groups: []
      rolearn: ${arn}
      username: eks-admin-${i}
%{endfor~}
EOT
    dev_role_arns         = <<EOT
%{for i, arn in var.dev_role_arns~}
    - groups: []
      rolearn: ${arn}
      username: eks-developer-${i}
%{endfor~}
EOT
    readonly_role_arns    = <<EOT
%{for i, arn in var.readonly_role_arns~}
    - groups: []
      rolearn: ${arn}
      username: eks-readonly-${i}
%{endfor~}
EOT
    admin_role_binding    = <<EOT
%{for i, arn in var.admin_role_arns~}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: eks:eks-admin-role-binding-${i}
subjects:
  - kind: User
    name: eks-admin-${i}
    apiGroup: "rbac.authorization.k8s.io"
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
%{endfor~}
EOT
    dev_role_binding      = <<EOT
%{for i, arn in var.dev_role_arns~}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: eks:eks-developer-role-binding-${i}
subjects:
  - kind: User
    name: eks-developer-${i}
    apiGroup: "rbac.authorization.k8s.io"
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: edit
%{endfor~}
EOT
    readonly_role_binding = <<EOT
%{for i, arn in var.readonly_role_arns~}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: eks:eks-readonly-role-binding-${i}
subjects:
  - kind: User
    name: eks-readonly-${i}
    apiGroup: "rbac.authorization.k8s.io"
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: view
%{endfor~}
EOT
    admin_iam_arns        = <<EOT
%{for i, arn in var.admin_iam_arns~}
    - userarn: ${arn}
      username: eks-iam-admin-${i}
      groups:
        - system:masters
%{endfor~}
EOT
  }
}

data "template_file" "scripts" {
  template = file("${path.module}/templates/scripts.sh")
  vars = {
    region                   = var.aws_account.region
    cluster_name             = var.cluster_name
    eks_bootstrap_secret_arn = aws_secretsmanager_secret.terraform_key.arn
    is_config_aws_auth       = var.is_config_aws_auth
    eks_manifest_file        = data.template_file.eks_manifest.rendered
  }
}

data "template_file" "cloud_init" {
  template = file("${path.module}/templates/cloud-init.yml")
}

data "template_cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = false

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.cloud_init.rendered
  }

  part {
    filename     = "user_data.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.scripts.rendered
  }
}
