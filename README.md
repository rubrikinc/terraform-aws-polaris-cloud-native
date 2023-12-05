# Terraform Module - AWS Rubrik Cloud Native

This module adds an AWS account to Rubrik Security Cloud (RSC/Polaris).

## Prerequisites

There are a few services you'll need in order to get this project off the ground:

- [Terraform](https://www.terraform.io/downloads.html) v1.5.6 or greater
- [Rubrik Polaris Provider for Terraform](https://github.com/rubrikinc/terraform-provider-polaris) - provides Terraform functions for Rubrik Security Cloud (Polaris)
- [Install the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) - Needed for Terraform to authenticate with AWS

## Usage

```hcl
# Setting up an AWS account that will host Exocompute
module "polaris-aws-cloud-native_exo_host" {
  source  = "rubrikinc/polaris-cloud-native/aws"
  
  polaris_credentials                 = "../.creds/customer-service-account.json"
  aws_account_name                    = "my_aws_account_hosted_exocompute"
  aws_account_id                      = "123456789012"
  aws_regions                         = ["us-west-2","us-east-1"]
  rsc_aws_exocompute_type                 = "Host"
  rsc_aws_exocompute_host_details     = {
    exocompute_config_1 = {
      aws_region        = "us-west-2"
      aws_vpc_id        = "vpc-0123456789abcdef0"
      aws_subnet_1_id   = "subnet-0123456789abcdef0"
      aws_subnet_2_id   = "subnet-fedcba9876543210f"
    }
    exocompute_config_2 = {
      aws_region        = "us-east-1"
      aws_vpc_id        = "vpc-abcdef01234567890"
      aws_subnet_1_id   = "subnet-abcdef01234567890"
      aws_subnet_2_id   = "subnet-9876543210fedcba9"
    }
  }
  rsc_aws_features                    = [
                                          "CLOUD_NATIVE_ARCHIVAL",
                                          "CLOUD_NATIVE_PROTECTION",
                                          "EXOCOMPUTE",
                                          "RDS_PROTECTION"
                                        ]
}

# Setting up an AWS account that will use shared Exocompute
module "polaris-aws-cloud-native_exo_shared" {
  source  = "rubrikinc/polaris-cloud-native/aws"
  
  polaris_credentials                 = "../.creds/customer-service-account.json"
  aws_account_name                    = "my_aws_account_shared_exocompute"
  aws_account_id                      = "098765432109"
  aws_regions                         = ["us-west-2","us-east-1"]
  rsc_aws_exocompute_host_account_id  = module.polaris-aws-cloud-native_exo_host.polaris_account_id
  rsc_aws_exocompute_type             = "Shared"
  rsc_aws_features                    = [
                                          "CLOUD_NATIVE_ARCHIVAL",
                                          "CLOUD_NATIVE_PROTECTION",
                                          "EXOCOMPUTE",
                                          "RDS_PROTECTION"
                                        ]
}
```

<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.5.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~>5.0 |
| <a name="requirement_polaris"></a> [polaris](#requirement\_polaris) | =0.8.0-beta.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.27.0 |
| <a name="provider_polaris"></a> [polaris](#provider\_polaris) | 0.8.0-beta.7 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.9.2 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [polaris_aws_cnp_account.account](https://registry.terraform.io/providers/rubrikinc/polaris/0.8.0-beta.7/docs/resources/aws_cnp_account) | resource |
| [polaris_aws_cnp_account_attachments.attachments](https://registry.terraform.io/providers/rubrikinc/polaris/0.8.0-beta.7/docs/resources/aws_cnp_account_attachments) | resource |
| [polaris_aws_cnp_account_trust_policy.trust_policy](https://registry.terraform.io/providers/rubrikinc/polaris/0.8.0-beta.7/docs/resources/aws_cnp_account_trust_policy) | resource |
| [polaris_aws_exocompute.host](https://registry.terraform.io/providers/rubrikinc/polaris/0.8.0-beta.7/docs/resources/aws_exocompute) | resource |
| [polaris_aws_exocompute.shared](https://registry.terraform.io/providers/rubrikinc/polaris/0.8.0-beta.7/docs/resources/aws_exocompute) | resource |
| [time_sleep.wait_for_polaris_sync](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [polaris_aws_cnp_artifacts.artifacts](https://registry.terraform.io/providers/rubrikinc/polaris/0.8.0-beta.7/docs/data-sources/aws_cnp_artifacts) | data source |
| [polaris_aws_cnp_permissions.permissions](https://registry.terraform.io/providers/rubrikinc/polaris/0.8.0-beta.7/docs/data-sources/aws_cnp_permissions) | data source |

## Modules

No modules.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS account ID to protect with Rubrik Security Cloud. | `string` | n/a | yes |
| <a name="input_aws_account_name"></a> [aws\_account\_name](#input\_aws\_account\_name) | AWS account name to protect with Rubrik Security Cloud. | `string` | n/a | yes |
| <a name="input_aws_ec2_recovery_role_path"></a> [aws\_ec2\_recovery\_role\_path](#input\_aws\_ec2\_recovery\_role\_path) | EC2 recovery role path for the cross account role. | `string` | `""` | no |
| <a name="input_aws_external_id"></a> [aws\_external\_id](#input\_aws\_external\_id) | External ID for the AWS cross account role. If left empty, RSC will automatically generate an external ID. | `string` | `""` | no |
| <a name="input_aws_regions"></a> [aws\_regions](#input\_aws\_regions) | AWS regions to protect with Rubrik Security Cloud. | `set(string)` | n/a | yes |
| <a name="input_aws_role_path"></a> [aws\_role\_path](#input\_aws\_role\_path) | AWS role path for cross account role. | `string` | `"/"` | no |
| <a name="input_polaris_credentials"></a> [polaris\_credentials](#input\_polaris\_credentials) | Path to the Rubrik Security Cloud service account file. | `string` | n/a | yes |
| <a name="input_rsc_aws_delete_snapshots_on_destroy"></a> [rsc\_aws\_delete\_snapshots\_on\_destroy](#input\_rsc\_aws\_delete\_snapshots\_on\_destroy) | Delete snapshots in AWS when account is removed from Rubrik Security Cloud. | `bool` | `false` | no |
| <a name="input_rsc_aws_exocompute_host_account_id"></a> [rsc\_aws\_exocompute\_host\_account\_id](#input\_rsc\_aws\_exocompute\_host\_account\_id) | Polaris account ID for the AWS account hosting Exocompute when "rsc\_aws\_exocompute\_type" is set to "Shared". | `string` | `"Set This Value"` | no |
| <a name="input_rsc_aws_exocompute_host_details"></a> [rsc\_aws\_exocompute\_host\_details](#input\_rsc\_aws\_exocompute\_host\_details) | Region(s), VPC(s) and subnet pairs to host Exocompute in when "rsc\_aws\_exocompute\_type" is set to "Host". | <pre>map(object({<br>    aws_region      = string<br>    aws_vpc_id      = string<br>    aws_subnet_1_id = string<br>    aws_subnet_2_id = string<br>  }))</pre> | <pre>{<br>  "exocompute_config_1": {<br>    "aws_region": "set the region",<br>    "aws_subnet_1_id": "set the subnet 1 id",<br>    "aws_subnet_2_id": "set the subnet 2 id",<br>    "aws_vpc_id": "set the vpc id"<br>  }<br>}</pre> | no |
| <a name="input_rsc_aws_exocompute_type"></a> [rsc\_aws\_exocompute\_type](#input\_rsc\_aws\_exocompute\_type) | Exocompute setting for the AWS account. | `string` | n/a | yes |
| <a name="input_rsc_aws_features"></a> [rsc\_aws\_features](#input\_rsc\_aws\_features) | Rubrik Security Cloud features to enable for the AWS account to be protected. | `set(string)` | n/a | yes |
| <a name="input_rsc_cloud_type"></a> [rsc\_cloud\_type](#input\_rsc\_cloud\_type) | AWS cloud type in RSC. | `string` | `"STANDARD"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_polaris_account_id"></a> [polaris\_account\_id](#output\_polaris\_account\_id) | n/a |


<!-- END_TF_DOCS -->