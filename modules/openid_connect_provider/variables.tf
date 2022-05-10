variable "prefix" {
  description = "The prefix name of customer to be displayed in AWS console and resource"
  type        = string
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

variable "cluster_oidc_issuer" {
  description = "cluster oidc issuer for create iam oidc provider"
  type        = string
}

variable "cluster_name" {
  description = "eks cluster name for setup iam policy to allow only cluster"
  type        = string
}

variable "is_create_loadbalancer_controller_sa" {
  description = "is create default role with permission for aws loadbalancer controller"
  type        = bool
  default     = true
}

variable "is_create_argo_image_updater_sa" {
  description = "is create default role with permission for argo-cd image updater"
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
