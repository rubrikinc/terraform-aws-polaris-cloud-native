variable "polaris_credentials" {
  type        = string
  description = "Path to the Rubrik Security Cloud service account file."
}

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

variable "aws_regions" {
  type        = set(string)
  description = "AWS regions to protect with Rubrik Security Cloud."
}

variable "aws_role_path" {
  type        = string
  default     = "/"
  description = "AWS role path for cross account role."
}

variable "rsc_cloud_type" {
  type        = string
  default     = "STANDARD"
  description = "AWS cloud type in RSC."
}

variable "rsc_aws_delete_snapshots_on_destroy" {
  type        = bool
  default     = false
  description = "Delete snapshots in AWS when account is removed from Rubrik Security Cloud."
}

variable "rsc_aws_exocompute_host_account_id" {
  type        = string
  description = "Polaris account ID for the AWS account hosting Exocompute when \"rsc_aws_exocompute_type\" is set to \"Shared\"."
  default = "Set This Value"
}

variable "rsc_aws_exocompute_host_details" {
  description = "Region(s), VPC(s) and subnet pairs to host Exocompute in when \"rsc_aws_exocompute_type\" is set to \"Host\"."
  type        = map(object({
    aws_region      = string
    aws_vpc_id      = string
    aws_subnet_1_id = string
    aws_subnet_2_id = string
  }))
  default = {
    exocompute_config_1 = {
      aws_region      = "set the region"
      aws_vpc_id      = "set the vpc id"
      aws_subnet_1_id = "set the subnet 1 id"
      aws_subnet_2_id = "set the subnet 2 id"
    }
  }
}

variable "rsc_aws_exocompute_type" {
  type        = string
  description = "Exocompute setting for the AWS account."
  validation {
    condition     = contains(["None", "Host", "Shared"], var.rsc_aws_exocompute_type)
    error_message = "Invalid input, options: \"None\", \"Host\", or \"Shared\"."
  }
}

variable "rsc_aws_features" {
  type        = set(string)
  description = "Rubrik Security Cloud features to enable for the AWS account to be protected."

  validation {
#    condition     = contains(["CLOUD_NATIVE_ARCHIVAL", "CLOUD_NATIVE_PROTECTION", "EXOCOMPUTE", "RDS_PROTECTION"], var.rsc_aws_features)
    condition     = alltrue([for val in var.rsc_aws_features : contains(["CLOUD_NATIVE_ARCHIVAL", "CLOUD_NATIVE_PROTECTION", "EXOCOMPUTE", "RDS_PROTECTION"], val)])
    error_message = "Invalid input, options: \"CLOUD_NATIVE_ARCHIVAL\", \"CLOUD_NATIVE_PROTECTION\", \"EXOCOMPUTE\", and/or \"RDS_PROTECTION\"."
  }
}