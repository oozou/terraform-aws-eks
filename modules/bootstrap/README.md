# AWS EKS Bootstrap Terraform Module

Terraform module with create ec2 for apply aws-auth and aws-lb-controller resources on EKS AWS.

## Usage

```terraform
module "bootstrap" {
  source                       = "./modules/bootstrap"
  subnet_id                    = "subnet-xxx"
  cluster_name                 = "test-cluster"
  admin_role_arns              = ["arn:xxxx:admin"]
  dev_role_arns                = ["arn:xxxx:dev"]
  readonly_role_arns           = ["arn:xxxx:readonly"]
  node_group_role_arn          = "arn:xxxx:nodegroup"
  oidc_arn                     = "arn:xxxx"
  vpc_id                       = "vpc-xxx"
  acm_arn                      = "arn:xxxx"
  argo_cd_domain               = "argo-cd.example.com"
  prefix                       = "oozou"
  is_config_aws_auth           = true
  is_config_aws_lb_controller  = true
  is_config_argo_cd            = true
  is_config_ingress_nginx      = true
  aws_account = {
    access_key = "xxxx"
    secret_key = "xxx"
    region     = "ap-southeast-1"
  }
  tags = {
    "test" : "example-tag"
  }
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.aws_lb_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.aws_lb_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.aws_lb_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_security_group.ec2_bootstrap](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_iam_openid_connect_provider.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |
| [aws_iam_policy_document.aws_lb_controller_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.aws_lb_controller_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [template_file.argo_cd_values](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.aws_lb_controller_sa](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.eks_manifest](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.ingress_nginx_values](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.user_data](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_arn"></a> [acm\_arn](#input\_acm\_arn) | if not specify aws will auto discovery on acm with same domain | `string` | `""` | no |
| <a name="input_admin_role_arns"></a> [admin\_role\_arns](#input\_admin\_role\_arns) | admin role arns for grant permission to aws-auth | `list(string)` | n/a | yes |
| <a name="input_argo_cd_domain"></a> [argo\_cd\_domain](#input\_argo\_cd\_domain) | domain for ingress argo-cd. require if is\_config\_argo\_cd is true | `string` | `""` | no |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | AWS Credentials to access AWS by bootstrap module | <pre>object({<br>    region     = string,<br>    access_key = string,<br>    secret_key = string<br>  })</pre> | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | cluster name for get kubeconfig | `any` | n/a | yes |
| <a name="input_dev_role_arns"></a> [dev\_role\_arns](#input\_dev\_role\_arns) | dev role arns for grant permission to aws-auth | `list(string)` | n/a | yes |
| <a name="input_is_config_argo_cd"></a> [is\_config\_argo\_cd](#input\_is\_config\_argo\_cd) | n/a | `bool` | `false` | no |
| <a name="input_is_config_aws_auth"></a> [is\_config\_aws\_auth](#input\_is\_config\_aws\_auth) | require if create lb controler | `bool` | `true` | no |
| <a name="input_is_config_aws_lb_controller"></a> [is\_config\_aws\_lb\_controller](#input\_is\_config\_aws\_lb\_controller) | require if create lb controler | `bool` | `true` | no |
| <a name="input_is_config_ingress_nginx"></a> [is\_config\_ingress\_nginx](#input\_is\_config\_ingress\_nginx) | n/a | `bool` | `false` | no |
| <a name="input_node_group_role_arn"></a> [node\_group\_role\_arn](#input\_node\_group\_role\_arn) | node group arn for grant permission to aws-auth | `string` | n/a | yes |
| <a name="input_oidc_arn"></a> [oidc\_arn](#input\_oidc\_arn) | require if create lb controler | `any` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix name of customer to be displayed in AWS console and resource | `string` | n/a | yes |
| <a name="input_readonly_role_arns"></a> [readonly\_role\_arns](#input\_readonly\_role\_arns) | readonly role group arns for grant permission to aws-auth | `list(string)` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | IDs of subnets for create instance | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tag for a resource taht create by this component | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | vpc id for create secgroup | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_ip"></a> [private\_ip](#output\_private\_ip) | n/a |
