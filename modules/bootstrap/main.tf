module "ec2" {
  source       = "git::ssh://git@github.com/oozou/terraform-aws-ec2-instance.git?ref=v1.0.0"
  prefix       = var.prefix
  environment  = var.environment
  ami          = data.aws_ami.ubuntu.id
  vpc_id       = var.vpc_id
  subnet_id    = var.subnet_id
  is_batch_run = true
  user_data    = data.template_cloudinit_config.user_data.rendered
  tags         = var.tags
}
