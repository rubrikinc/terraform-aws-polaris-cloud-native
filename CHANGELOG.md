# Changelog

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
