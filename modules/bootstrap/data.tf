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
    node_group_role_arn             = var.node_group_role_arn
    karpenter_node_role_arns        = <<EOT
%{for i, arn in var.karpenter_node_role_arns~}
    - groups:
      - system:bootstrappers
      - system:nodes
      rolearn: ${arn}
      username: system:node:{{EC2PrivateDNSName}}
%{endfor~}
EOT
    admin_role_arns                 = <<EOT
%{for i, arn in var.admin_role_arns~}
    - groups: []
      rolearn: ${arn}
      username: eks-admin-${i}
%{endfor~}
EOT
    dev_role_arns                   = <<EOT
%{for i, arn in var.dev_role_arns~}
    - groups: []
      rolearn: ${arn}
      username: eks-developer-${i}
%{endfor~}
EOT
    readonly_role_arns              = <<EOT
%{for i, arn in var.readonly_role_arns~}
    - groups: []
      rolearn: ${arn}
      username: eks-readonly-${i}
%{endfor~}
EOT
    admin_iam_arns                  = <<EOT
%{for i, arn in var.admin_iam_arns~}
    - userarn: ${arn}
      username: eks-iam-admin-${i}
      groups:
        - system:masters
%{endfor~}
EOT
    additional_map_roles            = <<EOT
%{for map_role in var.additional_map_roles~}
    - rolearn: ${map_role.role_arn}
      username: ${map_role.username}
      groups: []
%{endfor~}
EOT
    admin_role_binding              = <<EOT
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
    dev_role_binding                = <<EOT
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
    readonly_role_binding           = <<EOT
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
    additional_cluster_role         = <<EOT
%{for cluster_role in var.additional_cluster_role~}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: ${cluster_role.name}
rules:
  %{for rule in cluster_role.rules}
  - apiGroups: ${jsonencode(rule.apiGroups)}
    resources: ${jsonencode(rule.resources)}
    verbs: ${jsonencode(rule.verbs)}
  %{~endfor~}
%{endfor~}
EOT
    additional_cluster_role_binding = <<EOT
%{for cluster_role_binding in var.additional_cluster_role_binding~}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: ${cluster_role_binding.name}
subjects:
  %{for subject in cluster_role_binding.subjects}
  - kind: ${jsonencode(subject.kind)}
    name: ${jsonencode(subject.name)}
    apiGroup: ${jsonencode(subject.apiGroup)}
  %{~endfor~}
roleRef:
  apiGroup: ${cluster_role_binding.roleRef.apiGroup}
  kind: ${cluster_role_binding.roleRef.kind}
  name: ${cluster_role_binding.roleRef.name}
%{endfor~}
EOT
  }
}

data "template_file" "scripts" {
  template = file("${path.module}/templates/scripts.sh")
  vars = {
    region                   = var.aws_account.region
    cluster_name             = var.cluster_name
    kubectl_version          = var.kubectl_version
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
