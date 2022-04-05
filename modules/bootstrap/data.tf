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
    node_group_role_arn = var.node_group_role_arn
    admin_role_arns     = <<EOT
%{for i, arn in var.admin_role_arns~}
    - groups: []
      rolearn: ${arn}
      username: eks-admin-${i}
%{endfor~}
EOT
    dev_role_arns       = <<EOT
%{for i, arn in var.dev_role_arns~}
    - groups: []
      rolearn: ${arn}
      username: eks-developer-${i}
%{endfor~}
EOT
    readonly_role_arns  = <<EOT
%{for i, arn in var.readonly_role_arns~}
    - groups: []
      rolearn: ${arn}
      username: eks-readonly-${i}
%{endfor~}
EOT
    admin_role_binding = <<EOT
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
    dev_role_binding = <<EOT
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
  }
}

data "template_file" "aws_lb_controller_sa" {
  template = file("${path.module}/templates/aws-lb-controller-sa.yml")
  vars = {
    aws_lb_controller_role_arn = var.is_config_aws_lb_controller ? aws_iam_role.aws_lb_controller[0].arn : ""
  }
}

data "template_file" "argo_cd_values" {
  template = file("${path.module}/templates/argo-cd-values.yml")
  vars = {
    acm_arn        = var.acm_arn != "" ? var.acm_arn : "\"\""
    argo_cd_domain = var.argo_cd_domain
  }
}

data "template_file" "ingress_nginx_values" {
  template = file("${path.module}/templates/ingress-nginx-values.yml")
}


data "template_file" "scripts" {
  template = file("${path.module}/templates/scripts.sh")
  vars = {
    aws_access_key_id           = var.aws_account.access_key
    aws_secret_access_key       = var.aws_account.secret_key
    region                      = var.aws_account.region
    cluster_name                = var.cluster_name
    eks_manifest_file           = data.template_file.eks_manifest.rendered
    aws_lb_controller_sa        = data.template_file.aws_lb_controller_sa.rendered
    is_config_aws_auth          = var.is_config_aws_auth
    is_config_aws_lb_controller = var.is_config_aws_lb_controller
    is_config_argo_cd           = var.is_config_argo_cd
    argo_cd_values              = data.template_file.argo_cd_values.rendered
    argo_cd_domain              = var.argo_cd_domain
    is_config_ingress_nginx     = var.is_config_ingress_nginx
    ingress_nginx_values        = data.template_file.ingress_nginx_values.rendered
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
    filename     = "cloud-config.txt"
    content_type = "text/cloud-config; charset=\"us-ascii\""
    content      = data.template_file.cloud_init.rendered
  }

  part {
    filename     = "userdata.txt"
    content_type = "text/x-shellscript; charset=\"us-ascii\""
    content      = data.template_file.scripts.rendered
  }
}
