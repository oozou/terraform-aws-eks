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

variable "is_config_aws_auth" {
  description = "require if create lb controler"
  type        = bool
  default     = true
}

variable "vpc_id" {
  description = "vpc id for create secgroup"
  type        = string
}
