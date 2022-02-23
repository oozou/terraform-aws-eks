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

variable "node_group_role_arns" {
  description = "node group arn for grant permission to aws-auth"
  type        = list(string)
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