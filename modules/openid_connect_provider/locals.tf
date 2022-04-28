locals {
  prefix = "${var.prefix}-${var.environment}"
  loadbalancer_controller_sa = {
    name                 = "aws-load-balancer-controller"
    namespace = "kube-system"
    existing_policy_arns = [aws_iam_policy.aws_lb_controller[0].arn]
  }
  argo_image_updater_sa = {
    name                 = "argo-cd-image-updater"
    namespace = "argocd"
    existing_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"]
  }
  service_accounts = concat(
    var.is_create_loadbalancer_controller_sa ? [local.loadbalancer_controller_sa] : [],
    var.is_create_argo_image_updater_sa ? [local.argo_image_updater_sa] : [],
    var.additional_service_accounts
  )

}