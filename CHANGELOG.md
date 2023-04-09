# Change Log

All notable changes to this module will be documented in this file.

## [1.0.16] - 2022-04-10

Here we would have the update steps for 1.0.16 for people to follow.

### Added

- Support map iam user directly with aws-auth configmap

### Changed

- Update to support additional worker iam instance profile policy

## [1.0.15] - 2023-03-23

Here we would have the update steps for 1.0.15 for people to follow.

### Fixed

- worker node group name is too long

## [1.0.14] - 2022-09-29

Here we would have the update steps for 1.0.14 for people to follow.

### Changed

- public module

## [1.0.13] - 2022-08-11

Here we would have the update steps for 1.0.13 for people to follow.

### Added

- add `arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore` policy to default nodegroup role
  to support ssm service to node

### Changed

- change default variable for nodegroup `enable_monitoring` from `true` to `false`

## [1.0.12] - 2022-07-27

Here we would have the update steps for 1.0.12 for people to follow.

### Added

- support create before destroy nodegroup
- new nodegroup labels `nodegroup=<nodegroup-name>`

### Changed

- Changed default nodegroup label
  - from `eks.amazonaws.com/nodegroup=<nodegroup-name>` to `eks.amazonaws.com/nodegroup=<nodegroup-name><random-number>`
    to support create_before_destroy (nodegroup lifecycle)

- Variables
  - `is_enabled_cluster_encryption` changed default value from `false` to `true`

## [1.0.11] - 2022-07-18

Here we would have the update steps for 1.0.11 for people to follow.

### Changed

- Change Naming of Nodegroup (remove duplicate name)

## [1.0.10] - 2022-07-12

Here we would have the update steps for 1.0.10 for people to follow.

### Changed

- change version of kms module from `0.0.2` to `1.0.0`

## [1.0.9] - 2022-07-01

Here we would have the update steps for 1.0.9 for people to follow.

### Added

- resources
  - aws secretsmanager for store secret from bootstrap module

- variables
  - `bootstrap_kms_key_id`

### Changed

- move launch template (nodegroup sub module) from resource to terraform-aws-launch-template module
- change version of ec2 module from `1.0.4` to `1.0.5` for support SSM

## [1.0.8] - 2022-06-29

Here we would have the update steps for 1.0.8 for people to follow.

### Added

- new variables (Optional)
  - `cloudwatch_log_kms_key_id`
  - `cloudwatch_log_retention_in_days`

### Changed

- Rename `cluster_log_retention_in_days` to `cloudwatch_log_kms_key_id`

## [1.0.7] - 2022-06-13

Here we would have the update steps for 1.0.7 for people to follow.

### Added

- new resource
  - aws_launch_template


- new variables
  - `bootstrap_ami`

- new config for nodegroup variables (optional)
  - `platform`
  - `is_create_launch_template`
  - `enable_bootstrap_user_data`
  - `cluster_service_ipv4_cidr`
  - `pre_bootstrap_user_data`
  - `post_bootstrap_user_data`
  - `bootstrap_extra_args`
  - `ebs_optimized`
  - `ami_id`
  - `key_name`
  - `launch_template_default_version`
  - `update_launch_template_default_version`
  - `disable_api_termination`
  - `kernel_id`
  - `ram_disk_id`
  - `block_device_mappings`
  - `capacity_reservation_specification`
  - `cpu_options`
  - `credit_specification`
  - `elastic_gpu_specifications`
  - `elastic_inference_accelerator`
  - `enclave_options`
  - `instance_market_options`
  - `license_specifications`
  - `metadata_options`
  - `enable_monitoring`
  - `network_interfaces`
  - `placement`
  - `launch_template_tags`
  - ``

### Changed

- move nodegroup from nodegroup.tf to module (no change any variable)

## [1.0.6] - 2022-05-26

Here we would have the update steps for 1.0.6 for people to follow.

### Added

- new resource
  - kms
  - cloudwatch

- new variables
  - `enabled_cluster_log_types`
  - `cluster_log_retention_in_days`
  - `is_enabled_cluster_encryption`

- new output
  - `kms_key_arn`
  - `kms_key_id`
  - `cluster_security_group_id`
  - `cloudwatch_log_group_arn`

### Changed

- remove depend_on from bootstrap and oidc because it will destroy everychange but not necessary

## [1.0.5] - 2022-05-20

Here we would have the update steps for 1.0.5 for people to follow.

### Added

- support nodegroup taint

### Changed

- decease delay before create bootstrao from 5m to 3m
- nodegroup var from list to object
- additional addons from list to object

## [1.0.4] - 2022-05-13

Here we would have the update steps for 1.0.4 for people to follow.

### Added

- support custom nodegroup in public subnet

### Changed

- remove step for
  - install argo-cd
  - aws-load-balancer controller
  - nginx ingress controller

## [1.0.3] - 2022-05-10

Here we would have the update steps for 1.0.3 for people to follow.

### Added

- support additional_service_accounts

### Changed

- remove step for
  - install argo-cd
  - aws-load-balancer controller
  - nginx ingress controller

## [1.0.2] - 2022-04-22

Here we would have the update steps for 1.0.2 for people to follow.

### Added

- delay before create nodegroup

### Changed

- naming for eks bootstrap module
- naming argo-cd alb

## [1.0.1] - 2022-04-18
  
Here we would have the update steps for 1.0.1 for people to follow.

### Added

- add bootstrap module for automated setup eks
  - config aws-auth
  - install argo-cd
  - install nginx ingress
  - install aws-load-balancer-controller
- add default addons

## [1.0.0] - 2022-02-23

### Added

- init terraform-aws-eks module
