# Basic AWS account onboarding
The configuration in this directory adds an AWS account to RSC.

## Usage
To run this example you need to execute:
```bash
$ terraform init
$ terraform plan
$ terraform apply
```
Note that this example may create resources which can cost money. Run `terraform destroy` when you don't need these
resources.

<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >=5.26.0 |
| <a name="requirement_polaris"></a> [polaris](#requirement\_polaris) | >=1.0.0 |

## Providers

No providers.

## Resources

No resources.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cloud_native"></a> [cloud\_native](#module\_cloud\_native) | ../.. | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS account ID. | `string` | n/a | yes |
| <a name="input_aws_account_name"></a> [aws\_account\_name](#input\_aws\_account\_name) | AWS account name. | `string` | n/a | yes |
| <a name="input_aws_regions"></a> [aws\_regions](#input\_aws\_regions) | AWS regions. | `set(string)` | n/a | yes |

## Outputs

No outputs.

<!-- END_TF_DOCS -->
