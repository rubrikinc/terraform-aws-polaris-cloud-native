# Terraform Module - AWS Rubrik Cloud Native
This module adds an AWS account to Rubrik Security Cloud (RSC/Polaris).

## Usage

```hcl
module "cloud_native" {
  source  = "rubrikinc/polaris-cloud-native/aws"

  aws_account_id   = "123456789012"
  aws_account_name = "123456789012"
  aws_regions      = ["us-west-2","us-east-1"]

  rsc_aws_features = [
    {
      name              = "CLOUD_NATIVE_ARCHIVAL",
      permission_groups = ["BASIC"]
    },
    {
      name              = "CLOUD_NATIVE_PROTECTION"
      permission_groups = ["BASIC"]
    },
    {
      name              = "CLOUD_NATIVE_S3_PROTECTION"
      permission_groups = ["BASIC"]
    },
    {
      name              = "EXOCOMPUTE"
      permission_groups = ["BASIC", "RSC_MANAGED_CLUSTER"]
    },
    {
      name              = "RDS_PROTECTION",
      permission_groups = ["BASIC"]
    },
  ]
}
```

## Examples
- [Basic Onboarding](examples/basic)

## Changelog

# v0.5.0
* Relax the AWS provider version constraint to `>=5.26.0`.
* Relax the RSC (Polaris) provider version constraint to `>=1.0.0`.
* Remove the AWS and RSC (Polaris) provider blocks from the module. These must now be provided in the Terraform root
  module.
* Add module usage examples.
* Mark the `aws_profile` and `rsc_credentials` variables as deprecated. They are no longer used by the module and have
  no replacements.
* Add `aws_iam_role_type` input variable to support different ways to attach policies to the IAM roles created.
  Possible values are `legacy`, `inline` and `managed`. Defaults to `managed`. `legacy` should only be used for
  backwards compatibility with previously onboarded AWS accounts.
* Add support for specifying additional tags to the resources being created in AWS.

## Upgrading
Before upgrading the module, be sure to read through the changelog to understand the changes in the new version and any
upgrade instruction for the version you are upgrading to.

To upgrade the module to a new version, use the following steps:
1. Update the `version` field in the `module` block to the version you want to upgrade to, e.g. `version = "0.5.0"`.
2. Run `terraform init --upgrade` to update the providers and modules in your configuration.
3. Run `terraform plan` and check the output carefully to ensure that there are no unexpected changes caused by the
   upgrade.
4. Run `terraform apply` if there are expected changes that you want to apply.

Note, as variables in the module are deprecated, you may see warnings in the output of `terraform plan`. It's
recommended that you follow the instructions in the deprecation message. Eventually deprecated variables will be
removed.

<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.5.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.26.0 |
| <a name="requirement_polaris"></a> [polaris](#requirement\_polaris) | >=1.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >=5.26.0 |
| <a name="provider_polaris"></a> [polaris](#provider\_polaris) | >=1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.customer_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.customer_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.customer_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.rsc_roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.customer_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.customer_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachments_exclusive.customer_inline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachments_exclusive) | resource |
| [aws_iam_role_policy_attachments_exclusive.customer_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachments_exclusive) | resource |
| [polaris_aws_cnp_account.account](https://registry.terraform.io/providers/rubrikinc/polaris/latest/docs/resources/aws_cnp_account) | resource |
| [polaris_aws_cnp_account_attachments.attachments](https://registry.terraform.io/providers/rubrikinc/polaris/latest/docs/resources/aws_cnp_account_attachments) | resource |
| [polaris_aws_cnp_account_trust_policy.trust_policy](https://registry.terraform.io/providers/rubrikinc/polaris/latest/docs/resources/aws_cnp_account_trust_policy) | resource |
| [polaris_aws_cnp_artifacts.artifacts](https://registry.terraform.io/providers/rubrikinc/polaris/latest/docs/data-sources/aws_cnp_artifacts) | data source |
| [polaris_aws_cnp_permissions.permissions](https://registry.terraform.io/providers/rubrikinc/polaris/latest/docs/data-sources/aws_cnp_permissions) | data source |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS account ID to protect with Rubrik Security Cloud. | `string` | n/a | yes |
| <a name="input_aws_account_name"></a> [aws\_account\_name](#input\_aws\_account\_name) | AWS account name to protect with Rubrik Security Cloud. | `string` | n/a | yes |
| <a name="input_aws_ec2_recovery_role_path"></a> [aws\_ec2\_recovery\_role\_path](#input\_aws\_ec2\_recovery\_role\_path) | EC2 recovery role path for the cross account role. | `string` | `""` | no |
| <a name="input_aws_external_id"></a> [aws\_external\_id](#input\_aws\_external\_id) | External ID for the AWS cross account role. If left empty, RSC will automatically generate an external ID. | `string` | `""` | no |
| <a name="input_aws_iam_role_type"></a> [aws\_iam\_role\_type](#input\_aws\_iam\_role\_type) | How the AWS policies should be attached to the IAM roles created for RSC. Possible values: `managed`, `inline` and `legacy`. `legacy` should only be used for backwards compatibility with previously onboarded AWS accounts. | `string` | `"managed"` | no |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | AWS profile to use for the Rubrik Security Cloud account. | `string` | `null` | no |
| <a name="input_aws_regions"></a> [aws\_regions](#input\_aws\_regions) | AWS regions to protect with Rubrik Security Cloud. | `set(string)` | n/a | yes |
| <a name="input_aws_role_path"></a> [aws\_role\_path](#input\_aws\_role\_path) | AWS role path for cross account role. | `string` | `"/"` | no |
| <a name="input_rsc_aws_delete_snapshots_on_destroy"></a> [rsc\_aws\_delete\_snapshots\_on\_destroy](#input\_rsc\_aws\_delete\_snapshots\_on\_destroy) | Delete snapshots in AWS when account is removed from Rubrik Security Cloud. | `bool` | `false` | no |
| <a name="input_rsc_aws_features"></a> [rsc\_aws\_features](#input\_rsc\_aws\_features) | RSC features with permission groups to enable for the AWS account to be protected. | <pre>set(object({<br/>    name              = string<br/>    permission_groups = set(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_rsc_cloud_type"></a> [rsc\_cloud\_type](#input\_rsc\_cloud\_type) | AWS cloud type in RSC. | `string` | `"STANDARD"` | no |
| <a name="input_rsc_credentials"></a> [rsc\_credentials](#input\_rsc\_credentials) | Path to the Rubrik Security Cloud service account file. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to AWS resources created. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_eks_worker_node_role_arn"></a> [aws\_eks\_worker\_node\_role\_arn](#output\_aws\_eks\_worker\_node\_role\_arn) | n/a |
| <a name="output_aws_iam_cross_account_role_arn"></a> [aws\_iam\_cross\_account\_role\_arn](#output\_aws\_iam\_cross\_account\_role\_arn) | n/a |
| <a name="output_cluster_master_role_arn"></a> [cluster\_master\_role\_arn](#output\_cluster\_master\_role\_arn) | n/a |
| <a name="output_rsc_aws_cnp_account_id"></a> [rsc\_aws\_cnp\_account\_id](#output\_rsc\_aws\_cnp\_account\_id) | n/a |
| <a name="output_worker_instance_profile"></a> [worker\_instance\_profile](#output\_worker\_instance\_profile) | n/a |

<!-- END_TF_DOCS -->
