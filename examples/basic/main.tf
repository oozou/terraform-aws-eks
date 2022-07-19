module "eks" {
  source                        = "../../"
  name                          = "eks"
  prefix                        = local.prefix
  environment                   = local.environment
  vpc_id                        = module.vpc.vpc_id
  subnets_ids                   = module.vpc.private_subnet_ids
  is_endpoint_private_access    = false
  is_endpoint_public_access     = true
  is_enabled_cluster_encryption = true
  node_groups = {
    default = {
      desired_size      = 1,
      max_size          = 1,
      min_size          = 1,
      is_spot_instances = true
      disk_size         = null
      taint = [{
        key    = "dedicated"
        value  = "gpuGroup"
        effect = "NO_SCHEDULE"
      }]
      is_create_launch_template = true
      instance_types            = ["t3a.small"]
    }
  }
  is_create_loadbalancer_controller_sa = true
  is_create_cluster_autoscaler_sa      = true
  additional_service_accounts = [{
    name                 = "get-ecr"
    namespace            = "*"
    existing_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
  }]
  # need to set for config aws-auth
  is_config_aws_auth = true
  aws_account = {
    access_key = "access_key"
    secret_key = "secret_key"
    region     = "ap-southeast-1"
  }
  admin_role_arns    = []
  dev_role_arns      = []
  readonly_role_arns = []
  tags               = local.tags
}
