variable "prefix" {
  description = "The prefix name of customer to be displayed in AWS console and resource"
  type        = string
}

variable "name" {
  description = "The Name of the EKS cluster"
  type        = string
}

variable "environment" {
  description = "To manage a resources with tags"
  type        = string
}

variable "tags" {
  description = "Tag for a resource that create by this component"
  type        = map(string)
  default     = {}
}

variable "subnets_ids" {
  description = "List of IDs of subnets for create EKS"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC for create security group"
  type        = string
}

variable "is_endpoint_private_access" {
  description = "Whether the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "is_endpoint_public_access" {
  description = "Whether the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = false
}

variable "eks_version" {
  description = "Desired Kubernetes version. Downgrades are not supported by EKS."
  type        = string
  default     = null
}

variable "enabled_cluster_log_types" {
  description = "List of the desired control plane logging to enable" #https://docs.aws.amazon.com/eks/latest/userguide/control-plane-logs.html
  type        = list(string)
  default     = []
}

variable "cloudwatch_log_retention_in_days" {
  description = "Specifies the number of days you want to retain log events Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire"
  type        = number
  default     = 90
}

variable "cloudwatch_log_kms_key_id" {
  description = "The ARN for the KMS encryption key."
  type        = string
  default     = null
}

variable "is_enabled_cluster_encryption" {
  description = "if enable will create kms and config eks with kms key to encrpt secret"
  type        = bool
  default     = true
}

variable "node_groups" {
  description = " EKS Node Group for create EC2 as worker node"
  type        = map(any)
  default = {
    default = {
      # replace_subnets : use same subnet with cluster
      desired_size : 1,
      max_size : 1,
      min_size : 1,
      max_unavailable : 1,
      ami_type : "AL2_x86_64"
      is_spot_instances : false
      disk_size : 20,
      taint : {}
      labels : {
        default_nodegroup_labels = "default-nodegroup"
      }
      instance_types : ["t3.medium"]
  } }
}

variable "aws_account" {
  description = "AWS Credentials to access AWS by bootstrap module require if is_config_aws_auth = trues"
  type = object({
    region     = string,
    access_key = string,
    secret_key = string
  })
  sensitive = true
  default = {
    access_key = ""
    region     = ""
    secret_key = ""
  }
}

variable "karpenter_node_role_arns" {
  description = "Karpenter node role arns for grant permission to aws-auth"
  type        = list(string)
  default     = []
}

variable "admin_role_arns" {
  description = "admin role arns for grant permission to aws-auth"
  type        = list(string)
  default     = []
}

variable "dev_role_arns" {
  description = "dev role arns for grant permission to aws-auth"
  type        = list(string)
  default     = []
}

variable "readonly_role_arns" {
  description = "readonly role group arns for grant permission to aws-auth"
  type        = list(string)
  default     = []
}

variable "additional_cluster_role" {
  description = <<EOL
Additional cluster role resource
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
Additional cluster role resource
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

variable "admin_iam_arns" {
  description = "admin iam arns for grant permission to aws-auth"
  type        = list(string)
  default     = []
}

variable "additional_allow_cidr" {
  description = "cidr for allow connection to eks cluster"
  type        = list(string)
  default     = []
}

variable "is_config_aws_auth" {
  description = "require if create lb controler"
  type        = bool
  default     = true
}

variable "is_create_loadbalancer_controller_sa" {
  description = "is create default role with permission for aws loadbalancer controller (name : aws-load-balancer-controller)"
  type        = bool
  default     = true
}

variable "is_create_argo_image_updater_sa" {
  description = "is create default role with permission for argo-cd image updater (name : argo-cd-image-updater)"
  type        = bool
  default     = true
}

variable "is_create_cluster_autoscaler_sa" {
  description = "is create default role with permission for eks cluster autoscaler"
  type        = bool
  default     = true
}
variable "additional_service_accounts" {
  description = "additional service account to access eks"
  type = list(object({
    name                 = string
    namespace            = string
    existing_policy_arns = list(string)
  }))
  default = []
}

variable "additional_addons" {
  description = "additional addons for eks cluster"
  type        = map(any)
  default = {
    vpc-cni = {
      name = "vpc-cni",
    }
  }
}

variable "is_create_open_id_connect" {
  description = "if true will create oidc provider and iam role for service account"
  type        = bool
  default     = true
}

variable "is_create_bootstrap" {
  description = "if true will create bootstrap for config aws-auth"
  type        = bool
  default     = true
}

variable "bootstrap_kms_key_id" {
  description = "ARN or Id of the AWS KMS key to be used to encrypt the secret values in the versions stored in bootstrap secret. If you don't specify this value, then Secrets Manager defaults to using the AWS account's default KMS key (the one named aws/secretsmanager"
  type        = string
  default     = ""
}

variable "bootstrap_ami" {
  type        = string
  description = "AMI for ec2 bootstrap module"
  default     = ""
}

variable "additional_worker_polices" {
  description = "Additional IAM policies block, input as data source or json. Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document. Bucket Policy Statements can be overriden by the statement with the same sid from the latest policy."
  type        = list(string)
  default     = []
}
