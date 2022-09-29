resource "time_sleep" "delay_for_create_bootstrap" {
  create_duration = "1m"
  depends_on = [
    data.template_cloudinit_config.user_data
  ]
}

module "ec2" {
  source                    = "oozou/ec2-instance/aws"
  version                   = "1.0.5"
  prefix                    = var.prefix
  environment               = var.environment
  name                      = "eks-bootstrap"
  ami                       = var.ami != "" ? var.ami : data.aws_ami.ubuntu.id
  vpc_id                    = var.vpc_id
  subnet_id                 = var.subnet_id
  is_batch_run              = true
  is_create_default_profile = true
  override_profile_policy   = [data.aws_iam_policy_document.this.json]
  user_data                 = data.template_cloudinit_config.user_data.rendered
  tags                      = var.tags
  depends_on = [
    time_sleep.delay_for_create_bootstrap
  ]
}
