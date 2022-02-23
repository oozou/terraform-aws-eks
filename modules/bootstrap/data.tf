data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "aws_auth" {
  template = file("${path.module}/scripts/eks/aws_auth.yml")
  vars = {
    node_group_role_arn = var.node_group_role_arns[0]
    admin_role_arn      = var.admin_role_arn
    dev_role_arn        = var.dev_role_arn
    qa_role_arn         = var.qa_role_arn
  }
}

data "template_file" "startup" {
  template = file("${path.module}/scripts/startup.sh")
  vars = {
    aws_secret_access_key = var.aws_account.access_key
    aws_access_key_id     = var.aws_account.secret_key
    region                = var.aws_account.region
    cluster_name          = var.cluster_name
  }
}

data "template_file" "cloud_init" {
  template = file("${path.module}/scripts/cloud_init.yml")
  vars = {
    startup_script   = base64encode(data.template_file.startup.rendered)
    aws_auth         = base64encode(data.template_file.aws_auth.rendered)
    dev_role         = filebase64("${path.module}/scripts/eks/dev_role.yml")
    dev_role_binding = filebase64("${path.module}/scripts/eks/dev_role_binding.yml")
    qa_role          = filebase64("${path.module}/scripts/eks/qa_role.yml")
    qa_role_binding  = filebase64("${path.module}/scripts/eks/qa_role_binding.yml")
  }
}

data "template_cloudinit_config" "userdata" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.cloud_init.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.startup.rendered
  }
}

