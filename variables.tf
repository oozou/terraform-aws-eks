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

variable "endpoint_private_access" {
  description = "Whether the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "endpoint_public_access" {
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
    name            = string
    desired_size    = number
    max_size        = number
    min_size        = number
    max_unavailable = number
    instance_types  = list(string)

  }))
  default = [{
    name : "default",
    desired_size : 1,
    max_size : 1,
    min_size : 1,
    max_unavailable : 1,
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

variable "is_config_aws_lb_controller" {
  description = "require if create lb controler"
  type        = bool
  default     = true
}

variable "is_config_argo_cd" {
  description = "flag to install helm argo-cd on eks cluster"
  type        = bool
  default     = false
}

variable "is_config_ingress_nginx" {
  description = "flag to install helm nginx ingress controller"
  type        = bool
  default     = false
}

variable "acm_arn" {
  description = "if not specify aws will auto discovery on acm with same domain"
  type        = string
  default     = ""
}

variable "argo_cd_domain" {
  description = "domain for ingress argo-cd. require if is_config_argo_cd is true"
  type        = string
  default     = ""
}
