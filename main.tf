# Lookup the instance profiles and roles needed for the specified RSC features.
data "polaris_aws_cnp_artifacts" "artifacts" {
  cloud    = var.rsc_cloud_type
  features = var.rsc_aws_features
}

# Lookup the permission set, customer managed policies and managed policies,
# for each role given the current set of features.
data "polaris_aws_cnp_permissions" "permissions" {
  for_each               = data.polaris_aws_cnp_artifacts.artifacts.role_keys
  cloud                  = data.polaris_aws_cnp_artifacts.artifacts.cloud
  ec2_recovery_role_path = var.aws_ec2_recovery_role_path
  features               = data.polaris_aws_cnp_artifacts.artifacts.features
  role_key               = each.key
}

# Create the RSC AWS cloud account.
resource "polaris_aws_cnp_account" "account" {
  cloud                       = data.polaris_aws_cnp_artifacts.artifacts.cloud
  external_id                 = var.aws_external_id
  features                    = data.polaris_aws_cnp_artifacts.artifacts.features
  delete_snapshots_on_destroy = var.rsc_aws_delete_snapshots_on_destroy
  name                        = var.aws_account_name
  native_id                   = var.aws_account_id
  regions                     = var.aws_regions
}

# Create a trust policy per IAM role.
resource "polaris_aws_cnp_account_trust_policy" "trust_policy" {
  for_each    = data.polaris_aws_cnp_artifacts.artifacts.role_keys
  account_id  = polaris_aws_cnp_account.account.id
  features    = polaris_aws_cnp_account.account.features
  external_id = polaris_aws_cnp_account.account.external_id
  role_key    = each.key
}

# Create the required IAM roles.
resource "aws_iam_role" "rsc_roles" {
  for_each            = data.polaris_aws_cnp_artifacts.artifacts.role_keys
  assume_role_policy  = polaris_aws_cnp_account_trust_policy.trust_policy[each.key].policy
  managed_policy_arns = data.polaris_aws_cnp_permissions.permissions[each.key].managed_policies
  name_prefix         = "rubrik-${lower(each.key)}-"
  path                = var.aws_role_path

  dynamic "inline_policy" {
    for_each = data.polaris_aws_cnp_permissions.permissions[each.key].customer_managed_policies
    content {
      name   = inline_policy.value["name"]
      policy = inline_policy.value["policy"]
    }
  }
}

# Create the required IAM instance profiles.
resource "aws_iam_instance_profile" "profile" {
  for_each    = data.polaris_aws_cnp_artifacts.artifacts.instance_profile_keys
  name_prefix = "rubrik-${lower(each.key)}-"
  role        = aws_iam_role.rsc_roles[each.value].name
}

# Attach the instance profiles and the roles to the RSC cloud account.
resource "polaris_aws_cnp_account_attachments" "attachments" {
  account_id = polaris_aws_cnp_account.account.id
  features   = polaris_aws_cnp_account.account.features

  dynamic "instance_profile" {
    for_each = aws_iam_instance_profile.profile
    content {
      key  = instance_profile.key
      name = instance_profile.value["name"]
    }
  }

  dynamic "role" {
    for_each = aws_iam_role.rsc_roles
    content {
      key = role.key
      arn = role.value["arn"]
    }
  }
}