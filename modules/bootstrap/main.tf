resource "aws_instance" "this" {
  ami                                  = data.aws_ami.ubuntu.id
  instance_type                        = "t2.micro"
  subnet_id                            = var.subnet_id
  instance_initiated_shutdown_behavior = "terminate"
  user_data                            = data.template_file.user_data.rendered
  vpc_security_group_ids               = [aws_security_group.ec2_bootstrap.id]
  tags = merge(
    {
      "Name" = "${var.prefix}-bootstrap"
    },
    var.tags,
  )
}

resource "aws_security_group" "ec2_bootstrap" {
  name        = "${var.prefix}-ec2-bootstrap-sg"
  description = "ec2 bootstrap security group for allow egress"
  vpc_id      = var.vpc_id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(
    {
      "Name" = "${var.prefix}-ec2-bootstrap-sg"
    },
    var.tags,
  )
}