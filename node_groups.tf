module "nodegroup" {
  source      = "./modules/nodegroup"
  for_each    = var.node_groups
  prefix      = var.prefix
  environment = var.environment
  name        = each.key

  node_role_arn     = aws_iam_role.node_group_role.arn
  platform          = lookup(each.value, "platform", "linux")
  subnet_ids        = lookup(each.value, "replace_subnets", var.subnets_ids)
  instance_types    = lookup(each.value, "instance_types", ["t3.medium"])
  ami_type          = lookup(each.value, "ami_type", "AL2_x86_64")
  is_spot_instances = lookup(each.value, "is_spot_instances", false)
  disk_size         = lookup(each.value, "disk_size", 20)
  labels            = lookup(each.value, "labels", {})

  desired_size = lookup(each.value, "desired_size", 1)
  max_size     = lookup(each.value, "max_size", 1)
  min_size     = lookup(each.value, "min_size", 1)

  max_unavailable = lookup(each.value, "max_unavailable", 1)
  taint           = lookup(each.value, "taint", [])


  is_create_launch_template              = lookup(each.value, "is_create_launch_template", false)
  enable_bootstrap_user_data             = lookup(each.value, "enable_bootstrap_user_data", true)
  cluster_name                           = aws_eks_cluster.this.name
  cluster_endpoint                       = aws_eks_cluster.this.endpoint
  cluster_auth_base64                    = aws_eks_cluster.this.certificate_authority[0].data
  cluster_service_ipv4_cidr              = lookup(each.value, "cluster_service_ipv4_cidr", null)
  pre_bootstrap_user_data                = lookup(each.value, "pre_bootstrap_user_data", "")
  post_bootstrap_user_data               = lookup(each.value, "post_bootstrap_user_data", "")
  bootstrap_extra_args                   = lookup(each.value, "bootstrap_extra_args", "")
  ebs_optimized                          = lookup(each.value, "ebs_optimized", null)
  ami_id                                 = lookup(each.value, "ami_id", "")
  key_name                               = lookup(each.value, "key_name", null)
  vpc_security_group_ids                 = [aws_eks_cluster.this.vpc_config[0].cluster_security_group_id]
  launch_template_default_version        = lookup(each.value, "launch_template_default_version", null)
  update_launch_template_default_version = lookup(each.value, "update_launch_template_default_version", true)
  disable_api_termination                = lookup(each.value, "disable_api_termination", null)
  kernel_id                              = lookup(each.value, "kernel_id", null)
  ram_disk_id                            = lookup(each.value, "ram_disk_id", null)
  block_device_mappings                  = lookup(each.value, "block_device_mappings", {})
  capacity_reservation_specification     = lookup(each.value, "capacity_reservation_specification", null)
  cpu_options                            = lookup(each.value, "cpu_options", null)
  credit_specification                   = lookup(each.value, "credit_specification", null)
  elastic_gpu_specifications             = lookup(each.value, "elastic_gpu_specifications", null)
  elastic_inference_accelerator          = lookup(each.value, "elastic_inference_accelerator", null)
  enclave_options                        = lookup(each.value, "enclave_options", null)
  instance_market_options                = lookup(each.value, "instance_market_options", null)
  license_specifications                 = lookup(each.value, "license_specifications", null)
  metadata_options = lookup(each.value, "metadata_options", {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  })
  enable_monitoring    = lookup(each.value, "enable_monitoring", true)
  network_interfaces   = lookup(each.value, "network_interfaces", [])
  placement            = lookup(each.value, "placement", null)
  launch_template_tags = lookup(each.value, "launch_template_tags", {})
  tags                 = local.tags

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling
  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_readonly,
  ]
}
