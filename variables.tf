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


variable "node_groups" {
  description = " EKS Node Group for create EC2 as worker node"
  type = list(object({
    name              = string
    replace_subnets   = list(string)
    desired_size      = number
    max_size          = number
    min_size          = number
    max_unavailable   = number
    ami_type          = string
    is_spot_instances = bool
    disk_size         = number
    labels            = map(any) #for kubernetes api
    instance_types    = list(string)
    taint             = map(any)
  }))
  default = [{
    name : "default",
    replace_subnets : [], # empty if use same subnet with cluster
    desired_size : 1,
    max_size : 1,
    min_size : 1,
    max_unavailable : 1,
    ami_type : "AL2_x86_64"
    is_spot_instances : false
    disk_size : 20,
    taint : null
    labels : {
      default_nodegroup_labels = "default-nodegroup"
    }
    instance_types : ["t3.medium"]
  }]
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
  type        = list(string)
  default     = ["vpc-cni"]
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
