resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  tags = {
    Name = "bootstrap"
  }

  instance_initiated_shutdown_behavior = "terminate"
  user_data                            = data.template_cloudinit_config.userdata.rendered
}
