terraform {
  required_version = ">=1.5.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.26.0"
    }
    polaris = {
      source  = "rubrikinc/polaris"
      version = "=0.10.0-beta.9"
    }
  }
}

provider "aws" {
  retry_mode = "standard"
  profile    = var.aws_profile
}

provider "polaris" {
  credentials = var.rsc_credentials
}
