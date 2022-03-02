resource "aws_key_pair" "bootstrap" {
  key_name   = "bootstrap-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDESibg/Y30GcRl/62zfSdbNBNhEmVYrzmP8Gtrtjh22mG36vqn9hI8VSMFut+VnITYY5rIiaLyajhs7lVaEEL1arniiWib5tLHvfS18/DFeaYvqkPTSR0BphZpCltqi/3jD4NHT9VppxwNIsRe5hEYf9TrX0mvyT849M3zBiNtLkXf6xxnK8xX6AvremFq0yAgMHIpeYs22v/4PorUg1kt6m71KNtYJl5RiD57fdBV06EsQOFHqBo1kJqwo6L6ibDwRaaE/Qs7FxDE+Iu5CFcM2L+EC93AU75IfsWW8BEggMk8Ae66N14L0qGNpBHg2xsIBOP/vSo3yyWG9p5AV5bJ7AyRCJ3+HO9wKZXKVcQg0cd/YQgY8oWwkttx8q/F+EmQy4IRjh/9K6pwv/68CmHLgMxu8D3+8Cs4UmqW/vHXC6+O4DDc9kQShQI8QX7lL379cEvR7LoIHb7qVjK71C8eviNzbuLaBzSsvLEJxUe4p5UlLbL45TK8CyjmUq72vvM= waruwat@waruwats-MacBook-Air.local"
}

resource "aws_iam_instance_profile" "bootstrap" {
  name = "${var.cluster_name}-bootstrap-profile"
  role = aws_iam_role.bootstrap.name
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  tags = {
    Name = "bootstrap"
  }
  iam_instance_profile                 = aws_iam_instance_profile.bootstrap.id
  instance_initiated_shutdown_behavior = "terminate"
  user_data                            = data.template_file.user_data.rendered
  key_name                             = aws_key_pair.bootstrap.key_name
  vpc_security_group_ids               = [aws_security_group.allow_ssh.id]
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = "vpc-0fdff15f75fe4a67d"

  ingress {
    description = "ssh from other"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}


resource "aws_eip" "ip-bootstrap" {
  instance = aws_instance.this.id
  vpc      = true
}