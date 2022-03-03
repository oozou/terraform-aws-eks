resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  tags = {
    Name = "bootstrap"
  }
  instance_initiated_shutdown_behavior = "terminate"
  user_data                            = data.template_file.user_data.rendered
  vpc_security_group_ids               = [aws_security_group.allow_outbound.id]
}

resource "aws_security_group" "allow_outbound" {
  name        = "allow_outbound"
  description = "Allow outbound traffic"
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_outbound"
  }
}