variable "aws_account_id" {
  type        = string
  description = "AWS account ID to protect with Rubrik Security Cloud."
}

variable "aws_account_name" {
  type        = string
  description = "AWS account name to protect with Rubrik Security Cloud."
}

variable "aws_ec2_recovery_role_path" {
  type        = string
  default     = ""
  description = "EC2 recovery role path for the cross account role."
}

variable "aws_external_id" {
  type        = string
  default     = ""
  description = "External ID for the AWS cross account role. If left empty, RSC will automatically generate an external ID."
}

variable "aws_iam_role_type" {
  type        = string
  default     = "managed"
  description = "How the AWS policies should be attached to the IAM roles created for RSC. Possible values: `managed`, `inline` and `legacy`. `legacy` should only be used for backwards compatibility with previously onboarded AWS accounts."

  validation {
    condition     = can(regex("legacy|inline|managed", lower(var.aws_iam_role_type)))
    error_message = "Invalid AWS IAM role type. Possible values: `managed`, `inline` and `legacy`."
  }
}

variable "aws_regions" {
  type        = set(string)
  description = "AWS regions to protect with Rubrik Security Cloud."
}

variable "aws_role_path" {
  type        = string
  default     = "/"
  description = "AWS role path for cross account role."
}

variable "rsc_aws_delete_snapshots_on_destroy" {
  type        = bool
  default     = false
  description = "Delete snapshots in AWS when account is removed from Rubrik Security Cloud."
}

variable "rsc_aws_features" {
  type = set(object({
    name              = string
    permission_groups = set(string)
  }))
  description = "RSC features with permission groups to enable for the AWS account to be protected."
}

variable "rsc_cloud_type" {
  type        = string
  default     = "STANDARD"
  description = "AWS cloud type in RSC."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags to apply to AWS resources created."
}

# Deprecated variables.

variable "aws_profile" {
  type        = string
  default     = null
  description = "AWS profile to use for the Rubrik Security Cloud account."
}

variable "rsc_credentials" {
  type        = string
  default     = null
  description = "Path to the Rubrik Security Cloud service account file."
}

check "deprecations" {
  assert {
    condition     = var.aws_profile == null
    error_message = "The aws_profile variable has been deprecated. It has no replacement and will be removed in a future release. To continue using an AWS profile, pass the profile to the AWS provider block in the root module."
  }
  assert {
    condition     = var.rsc_credentials == null
    error_message = "The rsc_credentials variable has been deprecated. It has no replacement and will be removed in a future release. To continue using an RSC service account file, pass the file name to the Polaris provider block in the root module."
  }
}
