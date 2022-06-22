data "cloudinit_config" "linux_eks_managed_node_group" {
  base64_encode = true
  gzip          = false
  boundary      = "//"

  # Prepend to existing user data suppled by AWS EKS
  part {
    content_type = "text/x-shellscript"
    content      = local.int_linux_default_user_data
  }
}
