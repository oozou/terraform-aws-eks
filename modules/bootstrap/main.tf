resource "time_sleep" "delay_for_create_bootstrap" {
  create_duration = "1m"
  depends_on = [
    data.template_cloudinit_config.user_data
  ]
}

module "ec2" {
  source       = "git::ssh://git@github.com/oozou/terraform-aws-ec2-instance.git?ref=v1.0.2"
  prefix       = var.prefix
  environment  = var.environment
  name         = "eks-bootstrap"
  ami          = data.aws_ami.ubuntu.id
  vpc_id       = var.vpc_id
  subnet_id    = var.subnet_id
  is_batch_run = true
  user_data    = data.template_cloudinit_config.user_data.rendered
  tags         = var.tags
  depends_on = [
    time_sleep.delay_for_create_bootstrap
  ]
}
