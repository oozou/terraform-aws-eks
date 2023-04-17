# AWS EKS Terraform Module

Terraform module with create EKS resources on AWS.

![Design diagram](docs/design.png "Design diagram")

## Increase Limit of tcp, web socket, config kubelet for allow sysctl, 

default net.core.somaxconn = 4096, tcp_max_syn_backlog 512

```terraform
pre_bootstrap_user_data = "sysctl -w net.core.somaxconn='32767' net.ipv4.tcp_max_syn_backlog='32767' && contents=\"$(jq '.allowedUnsafeSysctls=[\"net.*\"]' /etc/kubernetes/kubelet/kubelet-config.json)\" && echo -E \"$${contents}\" > /etc/kubernetes/kubelet/kubelet-config.json"
```

## Addons

### vpc-cni

#### prerequisites

`If you are using vpc-cni addons you need to create them first create nodegroup and run below command`

```bash
kubectl set env daemonset aws-node -n kube-system ENABLE_PREFIX_DELEGATION=true #for enable interface /28
```

#### usage

```terraform
additional_addons = {
  vpc-cni = {
    name = "vpc-cni",
  }
}
```

### Amazon Elastic Block Store (EBS) CSI driver

#### prerequisites

iam role arn with policy below

- `arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy`
- (optional) custom policy with (kms) [see more](https://docs.aws.amazon.com/eks/latest/userguide/csi-iam-role.html)

#### usage

```terraform
additional_service_accounts = [{
  name                 = "ebs-csi-controller-sa"
  namespace            = "kube-system"
  existing_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy", "<custom-policy-to-allow-kms>"]
  }
]
additional_addons = {
  aws-ebs-csi-driver = {
    name = "aws-ebs-csi-driver",
    service_account_role_arn = <iam_role_arn_from_service_account>
  }
}
```

### AWS Distro for OpenTelemetry (ADOT)

#### prerequisites

- cert-manager

#### usage

##### prepare RBAC

```bash
kubectl apply -f https://amazon-eks.s3.amazonaws.com/docs/addons-otel-permissions.yaml
```

##### config terraform variables

```terraform
additional_service_accounts = [{
  name                 = "otel"
  namespace            = "opentelemetry-operator-system"
  existing_policy_arns = ["arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy", "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess", "arn:aws:iam::aws:policy/AmazonPrometheusRemoteWriteAccess"]
}]

additional_addons = {
  adot = {
    name    = "adot",
    version = "v0.45.0-eksbuild.1"
    existing_policy_arns = ["arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"]
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 3.2.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.62.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bootstrap"></a> [bootstrap](#module\_bootstrap) | ./modules/bootstrap | n/a |
| <a name="module_eks_kms"></a> [eks\_kms](#module\_eks\_kms) | oozou/kms-key/aws | 1.0.0 |
| <a name="module_nodegroup"></a> [nodegroup](#module\_nodegroup) | ./modules/nodegroup | n/a |
| <a name="module_openid_connect"></a> [openid\_connect](#module\_openid\_connect) | ./modules/openid_connect_provider | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eks_addon.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_iam_policy.combined_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.cluster_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node_group_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.amazon_ec2_container_registry_readonly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.amazon_ec2_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.amazon_eks_cluster_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.amazon_eks_cni_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.amazon_eks_vpc_resource_controller](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.amazon_eks_worker_node_combine_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.amazon_eks_worker_node_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.eks_egress_allow_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.eks_ingress_allow_tls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_iam_policy_document.cluster_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.combined_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.node_group_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | To manage a resources with tags | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The Name of the EKS cluster | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix name of customer to be displayed in AWS console and resource | `string` | n/a | yes |
| <a name="input_subnets_ids"></a> [subnets\_ids](#input\_subnets\_ids) | List of IDs of subnets for create EKS | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC for create security group | `string` | n/a | yes |
| <a name="input_additional_addons"></a> [additional\_addons](#input\_additional\_addons) | additional addons for eks cluster | `map(any)` | <pre>{<br>  "vpc-cni": {<br>    "name": "vpc-cni"<br>  }<br>}</pre> | no |
| <a name="input_additional_allow_cidr"></a> [additional\_allow\_cidr](#input\_additional\_allow\_cidr) | cidr for allow connection to eks cluster | `list(string)` | `[]` | no |
| <a name="input_additional_service_accounts"></a> [additional\_service\_accounts](#input\_additional\_service\_accounts) | additional service account to access eks | <pre>list(object({<br>    name                 = string<br>    namespace            = string<br>    existing_policy_arns = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_additional_worker_polices"></a> [additional\_worker\_polices](#input\_additional\_worker\_polices) | Additional IAM policies block, input as data source or json. Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document. Bucket Policy Statements can be overriden by the statement with the same sid from the latest policy. | `list(string)` | `[]` | no |
| <a name="input_admin_iam_arns"></a> [admin\_iam\_arns](#input\_admin\_iam\_arns) | admin iam arns for grant permission to aws-auth | `list(string)` | `[]` | no |
| <a name="input_admin_role_arns"></a> [admin\_role\_arns](#input\_admin\_role\_arns) | admin role arns for grant permission to aws-auth | `list(string)` | `[]` | no |
| <a name="input_aws_account"></a> [aws\_account](#input\_aws\_account) | AWS Credentials to access AWS by bootstrap module require if is\_config\_aws\_auth = trues | <pre>object({<br>    region     = string,<br>    access_key = string,<br>    secret_key = string<br>  })</pre> | <pre>{<br>  "access_key": "",<br>  "region": "",<br>  "secret_key": ""<br>}</pre> | no |
| <a name="input_bootstrap_ami"></a> [bootstrap\_ami](#input\_bootstrap\_ami) | AMI for ec2 bootstrap module | `string` | `""` | no |
| <a name="input_bootstrap_kms_key_id"></a> [bootstrap\_kms\_key\_id](#input\_bootstrap\_kms\_key\_id) | ARN or Id of the AWS KMS key to be used to encrypt the secret values in the versions stored in bootstrap secret. If you don't specify this value, then Secrets Manager defaults to using the AWS account's default KMS key (the one named aws/secretsmanager | `string` | `""` | no |
| <a name="input_cloudwatch_log_kms_key_id"></a> [cloudwatch\_log\_kms\_key\_id](#input\_cloudwatch\_log\_kms\_key\_id) | The ARN for the KMS encryption key. | `string` | `null` | no |
| <a name="input_cloudwatch_log_retention_in_days"></a> [cloudwatch\_log\_retention\_in\_days](#input\_cloudwatch\_log\_retention\_in\_days) | Specifies the number of days you want to retain log events Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire | `number` | `90` | no |
| <a name="input_dev_role_arns"></a> [dev\_role\_arns](#input\_dev\_role\_arns) | dev role arns for grant permission to aws-auth | `list(string)` | `[]` | no |
| <a name="input_eks_version"></a> [eks\_version](#input\_eks\_version) | Desired Kubernetes version. Downgrades are not supported by EKS. | `string` | `null` | no |
| <a name="input_enabled_cluster_log_types"></a> [enabled\_cluster\_log\_types](#input\_enabled\_cluster\_log\_types) | List of the desired control plane logging to enable | `list(string)` | `[]` | no |
| <a name="input_is_config_aws_auth"></a> [is\_config\_aws\_auth](#input\_is\_config\_aws\_auth) | require if create lb controler | `bool` | `true` | no |
| <a name="input_is_create_argo_image_updater_sa"></a> [is\_create\_argo\_image\_updater\_sa](#input\_is\_create\_argo\_image\_updater\_sa) | is create default role with permission for argo-cd image updater (name : argo-cd-image-updater) | `bool` | `true` | no |
| <a name="input_is_create_bootstrap"></a> [is\_create\_bootstrap](#input\_is\_create\_bootstrap) | if true will create bootstrap for config aws-auth | `bool` | `true` | no |
| <a name="input_is_create_cluster_autoscaler_sa"></a> [is\_create\_cluster\_autoscaler\_sa](#input\_is\_create\_cluster\_autoscaler\_sa) | is create default role with permission for eks cluster autoscaler | `bool` | `true` | no |
| <a name="input_is_create_loadbalancer_controller_sa"></a> [is\_create\_loadbalancer\_controller\_sa](#input\_is\_create\_loadbalancer\_controller\_sa) | is create default role with permission for aws loadbalancer controller (name : aws-load-balancer-controller) | `bool` | `true` | no |
| <a name="input_is_create_open_id_connect"></a> [is\_create\_open\_id\_connect](#input\_is\_create\_open\_id\_connect) | if true will create oidc provider and iam role for service account | `bool` | `true` | no |
| <a name="input_is_enabled_cluster_encryption"></a> [is\_enabled\_cluster\_encryption](#input\_is\_enabled\_cluster\_encryption) | if enable will create kms and config eks with kms key to encrpt secret | `bool` | `true` | no |
| <a name="input_is_endpoint_private_access"></a> [is\_endpoint\_private\_access](#input\_is\_endpoint\_private\_access) | Whether the Amazon EKS private API server endpoint is enabled | `bool` | `true` | no |
| <a name="input_is_endpoint_public_access"></a> [is\_endpoint\_public\_access](#input\_is\_endpoint\_public\_access) | Whether the Amazon EKS public API server endpoint is enabled | `bool` | `false` | no |
| <a name="input_karpenter_node_role_arns"></a> [karpenter\_node\_role\_arns](#input\_karpenter\_node\_role\_arns) | Karpenter node role arns for grant permission to aws-auth | `list(string)` | `[]` | no |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | EKS Node Group for create EC2 as worker node | `map(any)` | <pre>{<br>  "default": {<br>    "ami_type": "AL2_x86_64",<br>    "desired_size": 1,<br>    "disk_size": 20,<br>    "instance_types": [<br>      "t3.medium"<br>    ],<br>    "is_spot_instances": false,<br>    "labels": {<br>      "default_nodegroup_labels": "default-nodegroup"<br>    },<br>    "max_size": 1,<br>    "max_unavailable": 1,<br>    "min_size": 1,<br>    "taint": {}<br>  }<br>}</pre> | no |
| <a name="input_readonly_role_arns"></a> [readonly\_role\_arns](#input\_readonly\_role\_arns) | readonly role group arns for grant permission to aws-auth | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tag for a resource that create by this component | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_group_arn"></a> [cloudwatch\_log\_group\_arn](#output\_cloudwatch\_log\_group\_arn) | arn of cluster cloudwatch log group |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the cluster |
| <a name="output_cluster_security_group_id"></a> [cluster\_security\_group\_id](#output\_cluster\_security\_group\_id) | Cluster security group that was created by Amazon EKS for the cluster for control-plane-to-data-plane communication. |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | cluster endpoint for EKS |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | EKS encryption KMS key arn |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | EKS encryption KMS key id |
| <a name="output_kubeconfig_certificate_authority_data"></a> [kubeconfig\_certificate\_authority\_data](#output\_kubeconfig\_certificate\_authority\_data) | kubeconfig certificate |
| <a name="output_openid_connect_provider_arn"></a> [openid\_connect\_provider\_arn](#output\_openid\_connect\_provider\_arn) | arn of oidc provider |
| <a name="output_service_account_role_arns"></a> [service\_account\_role\_arns](#output\_service\_account\_role\_arns) | created role arn for create service accounts in cluster |
<!-- END_TF_DOCS -->
