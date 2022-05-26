# Change Log

All notable changes to this module will be documented in this file.

## [1.0.6] - 2022-05-26

Here we would have the update steps for 1.0.5 for people to follow.

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
