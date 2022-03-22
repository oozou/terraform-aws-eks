variable "prefix" {
  description = "The prefix name of customer to be displayed in AWS console and resource"
  type        = string
}

variable "subnet_id" {
  description = "IDs of subnets for create instance"
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
}

variable "node_group_role_arn" {
  description = "node group arn for grant permission to aws-auth"
  type        = string
}

variable "admin_role_arn" {
  description = "admin role arn for grant permission to aws-auth"
  type        = string
}

variable "dev_role_arn" {
  description = "dev role arn for grant permission to aws-auth"
  type        = string
}

variable "readonly_role_arn" {
  description = "readonly role group arn for grant permission to aws-auth"
  type        = string
}

variable "oidc_arn" {
  description = "require if create lb controler"
}

variable "config_aws_auth" {
  description = "require if create lb controler"
  default     = true
}

variable "config_aws_lb_controller" {
  description = "require if create lb controler"
  default     = true
}

variable "vpc_id" {
  description = "vpc id for create secgroup"
}
variable "is_config_argo_cd" {
  description = ""
  default     = false
}


variable "acm_arn" {
  description = "if not specify aws will auto discovery on acm with same domain"
  default     = ""
}

variable "argo_cd_domain" {
  description = "domain for ingress argo-cd. require if is_config_argo_cd is true"
  default     = ""
}
