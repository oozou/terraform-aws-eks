locals {
  prefix = format("%s-%s", var.prefix, var.environment)
  name   = format("%s-%s-nodegroup", local.prefix, var.name)
  int_linux_default_user_data = var.platform == "linux" && (var.enable_bootstrap_user_data) ? templatefile(
    "${path.module}/templates/linux_user_data.tpl",
    {
      # https://docs.aws.amazon.com/eks/latest/userguide/launch-templates.html#launch-template-custom-ami
      enable_bootstrap_user_data = var.enable_bootstrap_user_data
      # Required to bootstrap node
      cluster_name        = var.cluster_name
      cluster_endpoint    = var.cluster_endpoint
      cluster_auth_base64 = var.cluster_auth_base64
      # Optional
      cluster_service_ipv4_cidr = var.cluster_service_ipv4_cidr != null ? var.cluster_service_ipv4_cidr : ""
      bootstrap_extra_args      = var.bootstrap_extra_args
      pre_bootstrap_user_data   = var.pre_bootstrap_user_data
      post_bootstrap_user_data  = var.post_bootstrap_user_data
    }
  ) : ""
  platform = {
    linux = {
      user_data = data.cloudinit_config.linux_eks_managed_node_group.rendered
    }
  }
  labels = merge(
    { "nodegroup" = local.name },
  var.labels)
}

