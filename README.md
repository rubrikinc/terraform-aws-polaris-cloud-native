# Terraform Module - AWS Rubrik Cloud Native

This module adds an AWS account to Rubrik Security Cloud (RSC/Polaris).

## Prerequisites

There are a few services you'll need in order to get this project off the ground:

- [Terraform](https://www.terraform.io/downloads.html) v1.5.6 or greater
- [Rubrik Polaris Provider for Terraform](https://github.com/rubrikinc/terraform-provider-polaris) - provides Terraform functions for Rubrik Security Cloud (Polaris)
- [Install the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) - Needed for Terraform to authenticate with AWS

## Usage

```hcl
# Setting up an AWS account that will use all features.

module "polaris-aws-cloud-native" {
  source  = "rubrikinc/polaris-cloud-native/aws"
  
  aws_account_name  = "my_aws_account_hosted_exocompute"
  aws_account_id    = "123456789012"
  aws_regions       = ["us-west-2","us-east-1"]
  rsc_credentials   = "../.creds/customer-service-account.json"
  rsc_aws_features  = [
                      {
                        name              = "CLOUD_NATIVE_PROTECTION",
                        permission_groups = []
                      },
                      {
                        name              = "RDS_PROTECTION",
                        permission_groups = []
                      },
                      {
                        name              = "CLOUD_NATIVE_S3_PROTECTION"
                        permission_groups = []
                      },
                      {
                        name              = "EXOCOMPUTE"
                        permission_groups = []
                      },
                      {
                        name = "CLOUD_NATIVE_ARCHIVAL",
                        permission_groups = []
                      }
                    ]
}
```

<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.5.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>5.26.0 |
| <a name="requirement_polaris"></a> [polaris](#requirement\_polaris) | =0.8.0-beta.11 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.26.0 |
| <a name="provider_polaris"></a> [polaris](#provider\_polaris) | 0.8.0-beta.11 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.rsc_roles](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [polaris_aws_cnp_account.account](https://registry.terraform.io/providers/rubrikinc/polaris/0.8.0-beta.11/docs/resources/aws_cnp_account) | resource |
| [polaris_aws_cnp_account_attachments.attachments](https://registry.terraform.io/providers/rubrikinc/polaris/0.8.0-beta.11/docs/resources/aws_cnp_account_attachments) | resource |
| [polaris_aws_cnp_account_trust_policy.trust_policy](https://registry.terraform.io/providers/rubrikinc/polaris/0.8.0-beta.11/docs/resources/aws_cnp_account_trust_policy) | resource |
| [polaris_aws_cnp_artifacts.artifacts](https://registry.terraform.io/providers/rubrikinc/polaris/0.8.0-beta.11/docs/data-sources/aws_cnp_artifacts) | data source |
| [polaris_aws_cnp_permissions.permissions](https://registry.terraform.io/providers/rubrikinc/polaris/0.8.0-beta.11/docs/data-sources/aws_cnp_permissions) | data source |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS account ID to protect with Rubrik Security Cloud. | `string` | n/a | yes |
| <a name="input_aws_account_name"></a> [aws\_account\_name](#input\_aws\_account\_name) | AWS account name to protect with Rubrik Security Cloud. | `string` | n/a | yes |
| <a name="input_aws_ec2_recovery_role_path"></a> [aws\_ec2\_recovery\_role\_path](#input\_aws\_ec2\_recovery\_role\_path) | EC2 recovery role path for the cross account role. | `string` | `""` | no |
| <a name="input_aws_external_id"></a> [aws\_external\_id](#input\_aws\_external\_id) | External ID for the AWS cross account role. If left empty, RSC will automatically generate an external ID. | `string` | `""` | no |
| <a name="input_aws_profile"></a> [aws\_profile](#input\_aws\_profile) | AWS profile to use for the Rubrik Security Cloud account. | `string` | n/a | yes |
| <a name="input_aws_regions"></a> [aws\_regions](#input\_aws\_regions) | AWS regions to protect with Rubrik Security Cloud. | `set(string)` | n/a | yes |
| <a name="input_aws_role_path"></a> [aws\_role\_path](#input\_aws\_role\_path) | AWS role path for cross account role. | `string` | `"/"` | no |
| <a name="input_rsc_aws_delete_snapshots_on_destroy"></a> [rsc\_aws\_delete\_snapshots\_on\_destroy](#input\_rsc\_aws\_delete\_snapshots\_on\_destroy) | Delete snapshots in AWS when account is removed from Rubrik Security Cloud. | `bool` | `false` | no |
| <a name="input_rsc_aws_features"></a> [rsc\_aws\_features](#input\_rsc\_aws\_features) | RSC features with permission groups. | <pre>set(object({<br>    name              = string<br>    permission_groups = set(string)<br>  }))</pre> | n/a | yes |
| <a name="input_rsc_cloud_type"></a> [rsc\_cloud\_type](#input\_rsc\_cloud\_type) | AWS cloud type in RSC. | `string` | `"STANDARD"` | no |
| <a name="input_rsc_credentials"></a> [rsc\_credentials](#input\_rsc\_credentials) | Path to the Rubrik Security Cloud service account file. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_eks_worker_node_role_arn"></a> [aws\_eks\_worker\_node\_role\_arn](#output\_aws\_eks\_worker\_node\_role\_arn) | n/a |
| <a name="output_aws_iam_cross_account_role_arn"></a> [aws\_iam\_cross\_account\_role\_arn](#output\_aws\_iam\_cross\_account\_role\_arn) | n/a |
| <a name="output_cluster_master_role_arn"></a> [cluster\_master\_role\_arn](#output\_cluster\_master\_role\_arn) | n/a |
| <a name="output_rsc_aws_cnp_account_id"></a> [rsc\_aws\_cnp\_account\_id](#output\_rsc\_aws\_cnp\_account\_id) | n/a |
| <a name="output_worker_instance_profile"></a> [worker\_instance\_profile](#output\_worker\_instance\_profile) | n/a |


<!-- END_TF_DOCS -->