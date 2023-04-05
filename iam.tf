# cluster policy
data "aws_iam_policy_document" "cluster_role" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "cluster_role" {
  name               = "${local.prefix}-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.cluster_role.json
  tags = merge(
    {
      "Name" = "${local.prefix}-cluster-role"
    },
    local.tags
  )
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}

# enable Security Groups for Pods
resource "aws_iam_role_policy_attachment" "amazon_eks_vpc_resource_controller" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster_role.name
}

# node group policy
data "aws_iam_policy_document" "node_group_role" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "node_group_role" {
  name               = "${local.prefix}-node-group-role"
  assume_role_policy = data.aws_iam_policy_document.node_group_role.json
  tags = merge(
    {
      "Name" = "${local.prefix}-node-group-role"
    },
    local.tags
  )
}

resource "aws_iam_role_policy_attachment" "additional_eks_worker_node" {
  count = var.is_create_iam_role ? length(var.additional_eks_worker_node_role_policy_arns) : 0

  role       = aws_iam_role.node_group_role.name
  policy_arn = var.additional_eks_worker_node_role_policy_arns[count.index]
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node_group_role.name
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node_group_role.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node_group_role.name
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.node_group_role.name
}
