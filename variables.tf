variable "name" {
  description = "The Name of the EKS cluster"
}

variable "environment" {
  description = "To manage a resources with tags"
  type        = string
}

variable "tags" {
  description = "Tag for a resource taht create by this component"
  type        = map(string)
  default     = {}
}

variable "subnets_ids" {
  description = "List of IDs of subnets for create EKS"
}

variable "vpc_id" {
  description = "The ID of the VPC for create security group"
}

variable "endpoint_private_access" {
  description = "Whether the Amazon EKS private API server endpoint is enabled"
  default     = true
}

variable "endpoint_public_access" {
  description = "Whether the Amazon EKS public API server endpoint is enabled"
  default     = false
}

variable "eks_version" {
  description = "Desired Kubernetes version. Downgrades are not supported by EKS."
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
    name : "default-node-group",
    desired_size : 1,
    max_size : 1,
    min_size : 1,
    max_unavailable : 1,
    instance_types : ["t3.medium"]
  }]
}

variable "admin_user_arns" {
  description = "Principals to trust assume role policy and add to eks admin group for assume role"
  default     = []
}

variable "aws_bootstrap_account" {
  description = "AWS Credentials to access AWS by bootstrap module"
  type = object({
    region     = string,
    access_key = string,
    secret_key = string
  })
  sensitive = true
}

variable "admin_role_arn" {
  description = "admin role arn for grant permission to aws-auth"
  type        = string
}

variable "dev_role_arn" {
  description = "dev role arn for grant permission to aws-auth"
  type        = string
}

variable "qa_role_arn" {
  description = "qa role group arn for grant permission to aws-auth"
  type        = string
}
