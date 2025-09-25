terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.26.0"
    }
    polaris = {
      source  = "rubrikinc/polaris"
      version = ">=1.0.0"
    }
  }
}

variable "aws_account_id" {
  type        = string
  description = "AWS account ID."
}

variable "aws_account_name" {
  type        = string
  description = "AWS account name."
}

variable "aws_regions" {
  type        = set(string)
  description = "AWS regions."
}

provider "aws" {}

provider "polaris" {}

module "cloud_native" {
  source = "../.."

  aws_account_id   = var.aws_account_id
  aws_account_name = var.aws_account_name
  aws_regions      = var.aws_regions

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

  tags = {
    Environment = "test"
    Example     = "basic"
    Module      = "terraform-aws-polaris-cloud-native"
  }
}
