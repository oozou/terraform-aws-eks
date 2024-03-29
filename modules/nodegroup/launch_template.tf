module "launch_template" {
  source  = "oozou/launch-template/aws"
  version = "1.0.3"

  count                                  = var.is_create_launch_template ? 1 : 0
  prefix                                 = var.prefix
  environment                            = var.environment
  name                                   = var.name
  user_data                              = local.platform[var.platform].user_data
  ebs_optimized                          = var.ebs_optimized
  ami_id                                 = var.ami_id
  key_name                               = var.key_name
  vpc_security_group_ids                 = var.vpc_security_group_ids
  launch_template_default_version        = var.launch_template_default_version
  update_launch_template_default_version = var.update_launch_template_default_version
  disable_api_termination                = var.disable_api_termination
  kernel_id                              = var.kernel_id
  ram_disk_id                            = var.ram_disk_id
  block_device_mappings                  = var.block_device_mappings
  capacity_reservation_specification     = var.capacity_reservation_specification
  cpu_options                            = var.cpu_options
  credit_specification                   = var.credit_specification
  elastic_gpu_specifications             = var.elastic_gpu_specifications
  elastic_inference_accelerator          = var.elastic_inference_accelerator
  enclave_options                        = var.enclave_options
  instance_market_options                = var.instance_market_options
  license_specifications                 = var.license_specifications
  metadata_options                       = var.metadata_options
  enable_monitoring                      = var.enable_monitoring
  network_interfaces                     = var.network_interfaces
  placement                              = var.placement
  launch_template_tags                   = var.launch_template_tags
  tags                                   = var.tags
}
