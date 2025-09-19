# Changelog

## v0.5.2
* Update changelog.

## v0.5.1
* Make use of the `permissions` field in the `polaris_aws_cnp_account_attachments` resource to trigger an update of the
  resource whenever the permissions changes. This update will move the RSC cloud account from the missing permissions
  state. See the RSC (polaris) provider [upgrade guide](https://registry.terraform.io/providers/rubrikinc/polaris/latest/docs/guides/upgrade_guide_v1.0.0#new-permissions-field)
  for additional information.

## v0.5.0
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
