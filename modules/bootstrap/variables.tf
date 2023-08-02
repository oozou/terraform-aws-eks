variable "prefix" {
  description = "The prefix name of customer to be displayed in AWS console and resource"
  type        = string
}

variable "environment" {
  description = "To manage a resources with tags"
  type        = string
}

variable "subnet_id" {
  description = "IDs of subnets for create instance"
  type        = string
}

variable "ami" {
  type        = string
  description = "AMI for ec2 bootstrap module"
}

variable "tags" {
  description = "Tag for a resource taht create by this component"
  type        = map(string)
  default     = {}
}

variable "aws_account" {
  description = "AWS Credentials to access AWS by bootstrap module"
  type = object({
    region     = string,
    access_key = string,
    secret_key = string
  })
  sensitive = true
}

variable "cluster_name" {
  description = "cluster name for get kubeconfig"
  type        = string
}

variable "node_group_role_arn" {
  description = "node group arn for grant permission to aws-auth"
  type        = string
}

variable "karpenter_node_role_arns" {
  description = "Karpenter node role arns for grant permission to aws-auth"
  type        = list(string)
  default     = []
}

variable "admin_role_arns" {
  description = "admin role arns for grant permission to aws-auth"
  type        = list(string)
}

variable "dev_role_arns" {
  description = "dev role arns for grant permission to aws-auth"
  type        = list(string)
}

variable "readonly_role_arns" {
  description = "readonly role group arns for grant permission to aws-auth"
  type        = list(string)
}

variable "admin_iam_arns" {
  description = "admin iam arns for grant permission to aws-auth"
  type        = list(string)
}

variable "additional_cluster_role" {
  description = <<EOL
Additional cluster role resource ex.
additional_cluster_role = [
  {
    name = "cluster_role_name"
    rules = [
      { # Workloads
        apiGroups = ["*"]
        resources = ["pods", "deployments", "replicasets"]
        verbs     = ["get", "list", "watch", "create", "update", "delete", "patch"]
      },
      { # Config
        apiGroups = ["*"]
        resources = ["configmaps", "secrets", "horizontalpodautoscalers"]
        verbs     = ["get", "list", "watch", "create", "update", "delete", "patch"]
      },
      { # Network
        apiGroups = ["*"]
        resources = ["services", "ingresses"]
        verbs     = ["get", "list", "watch", "create", "update", "delete", "patch"]
    ]
  }
]
EOL
  type        = any
  default     = []
}

variable "additional_cluster_role_binding" {
  description = <<EOL
Additional cluster role resource ex.
additional_cluster_role_binding = [
  {
    name = "bdd"
    subjects = [
      {
        kind     = "User"
        name     = "role"
        apiGroup = "rbac.authorization.k8s.io"
      },
      {
        kind     = "User"
        name     = "role-x"
        apiGroup = "rbac.authorization.k8s.io"
      }
    ]
    roleRef = {
      apiGroup = "rbac.authorization.k8s.iox"
      kind     = "ClusterRole"
      name     = "devops-clusterrole"
    }
  }
]
EOL
  type        = any
  default     = []
}

variable "additional_map_roles" {
  description = <<EOL
Additional role to map ex.
additional_map_roles = [
  {
    role_arn = arn:aws:iam::502734123891:role/cicd-role
    username = dev-cicd-role
  }
]
EOL
  type        = any
  default     = []
}

variable "is_config_aws_auth" {
  description = "require if create lb controler"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "vpc id for create secgroup"
  type        = string
}

variable "kms_key_id" {
  description = "ARN or Id of the AWS KMS key to be used to encrypt the secret values in the versions stored in this secret. If you don't specify this value, then Secrets Manager defaults to using the AWS account's default KMS key (the one named aws/secretsmanager"
  type        = string
  default     = ""
}
