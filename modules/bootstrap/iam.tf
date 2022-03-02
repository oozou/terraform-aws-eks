data "aws_iam_policy_document" "bootstrap" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "bootstrap" {
  name               = "${var.cluster_name}-bootstrap"
  assume_role_policy = data.aws_iam_policy_document.bootstrap.json

  tags = merge({
    "Name" = "${var.cluster_name}-bootstrap"
  }, var.tags)
}

resource "aws_iam_role_policy_attachment" "access_ecr" {
  role       = aws_iam_role.bootstrap.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}