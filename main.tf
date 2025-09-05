# Lookup the instance profiles and roles needed for the specified RSC features.
data "polaris_aws_cnp_artifacts" "artifacts" {
  cloud = var.rsc_cloud_type

  dynamic "feature" {
    for_each = var.rsc_aws_features
    content {
      name              = feature.value["name"]
      permission_groups = feature.value["permission_groups"]
    }
  }

}

# Lookup the permission set, customer managed policies and managed policies,
# for each role given the current set of features.
data "polaris_aws_cnp_permissions" "permissions" {
  for_each               = data.polaris_aws_cnp_artifacts.artifacts.role_keys
  cloud                  = data.polaris_aws_cnp_artifacts.artifacts.cloud
  ec2_recovery_role_path = var.aws_ec2_recovery_role_path
  role_key               = each.key

  dynamic "feature" {
    for_each = var.rsc_aws_features
    content {
      name              = feature.value["name"]
      permission_groups = feature.value["permission_groups"]
    }
  }
}

#Create the RSC AWS cloud account.
resource "polaris_aws_cnp_account" "account" {
  cloud                       = data.polaris_aws_cnp_artifacts.artifacts.cloud
  external_id                 = var.aws_external_id
  delete_snapshots_on_destroy = var.rsc_aws_delete_snapshots_on_destroy
  name                        = var.aws_account_name
  native_id                   = var.aws_account_id
  regions                     = var.aws_regions
  dynamic "feature" {
    for_each = var.rsc_aws_features
    content {
      name              = feature.value["name"]
      permission_groups = feature.value["permission_groups"]
    }
  }
}

# Create a trust policy per IAM role.
resource "polaris_aws_cnp_account_trust_policy" "trust_policy" {
  for_each    = data.polaris_aws_cnp_artifacts.artifacts.role_keys
  account_id  = polaris_aws_cnp_account.account.id
  features    = polaris_aws_cnp_account.account.feature.*.name
  external_id = polaris_aws_cnp_account.account.external_id
  role_key    = each.key
}

# Attach the instance profiles and the roles to the RSC cloud account.
resource "polaris_aws_cnp_account_attachments" "attachments" {
  account_id = polaris_aws_cnp_account.account.id
  features   = polaris_aws_cnp_account.account.feature.*.name

  dynamic "instance_profile" {
    for_each = aws_iam_instance_profile.profile
    content {
      key  = instance_profile.key
      name = instance_profile.value["arn"]
    }
  }

  dynamic "role" {
    for_each = local.roles
    content {
      key = role.key
      arn = role.value["arn"]
    }
  }
}
