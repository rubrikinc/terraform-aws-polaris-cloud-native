locals {
  customer_managed_policies = merge([
    for key, value in data.polaris_aws_cnp_permissions.permissions : {
      for policy in value.customer_managed_policies : policy.name => {
        role_key = key,
        policy   = policy.policy,
      }
    }
  ]...)

  # Determine how to set up the IAM roles in AWS. Legacy uses a deprecated way
  # to create IAM roles with inline policies. Inline uses a non-deprecated way
  # to create IAM roles with inline policies. Managed creates IAM roles with
  # customer managed policies.
  legacy_iam_roles           = lower(var.aws_iam_role_type) == "legacy"
  customer_inline_iam_roles  = lower(var.aws_iam_role_type) == "inline"
  customer_managed_iam_roles = lower(var.aws_iam_role_type) == "managed"

  # Roles refers to the AWS IAM role resources configured.
  roles = local.customer_inline_iam_roles ? aws_iam_role.customer_inline : local.customer_managed_iam_roles ? aws_iam_role.customer_managed : aws_iam_role.rsc_roles
}

# Create the required IAM instance profiles.
resource "aws_iam_instance_profile" "profile" {
  for_each    = data.polaris_aws_cnp_artifacts.artifacts.instance_profile_keys
  name_prefix = "rubrik-${lower(each.key)}-"
  role        = local.roles[each.value].name
  tags        = var.tags
}

# Legacy. Note, this has been deprecated in the AWS provider.

# Create the required IAM roles.
resource "aws_iam_role" "rsc_roles" {
  for_each            = local.legacy_iam_roles ? data.polaris_aws_cnp_artifacts.artifacts.role_keys : []
  assume_role_policy  = polaris_aws_cnp_account_trust_policy.trust_policy[each.key].policy
  managed_policy_arns = data.polaris_aws_cnp_permissions.permissions[each.key].managed_policies
  name_prefix         = "rubrik-${lower(each.key)}-"
  path                = var.aws_role_path
  tags                = var.tags

  dynamic "inline_policy" {
    for_each = data.polaris_aws_cnp_permissions.permissions[each.key].customer_managed_policies
    content {
      name   = inline_policy.value["name"]
      policy = inline_policy.value["policy"]
    }
  }
}

# Customer inline.

# Create the required IAM roles.
resource "aws_iam_role" "customer_inline" {
  for_each           = local.customer_inline_iam_roles ? data.polaris_aws_cnp_artifacts.artifacts.role_keys : []
  assume_role_policy = polaris_aws_cnp_account_trust_policy.trust_policy[each.key].policy
  name_prefix        = "rubrik-${lower(each.key)}-"
  path               = var.aws_role_path
  tags               = var.tags
}

# Create customer inline IAM policies and attach them to the IAM roles.
resource "aws_iam_role_policy" "customer_inline" {
  for_each = local.customer_inline_iam_roles ? local.customer_managed_policies : {}
  name     = each.key
  policy   = each.value.policy
  role     = aws_iam_role.customer_inline[each.value.role_key].name
}

# Attach the AWS managed policies to the IAM roles.
resource "aws_iam_role_policy_attachments_exclusive" "customer_inline" {
  for_each    = local.customer_inline_iam_roles ? data.polaris_aws_cnp_permissions.permissions : {}
  role_name   = aws_iam_role.customer_inline[each.key].name
  policy_arns = each.value.managed_policies
}

# Customer managed.

# Create the required IAM roles.
resource "aws_iam_role" "customer_managed" {
  for_each           = local.customer_managed_iam_roles ? data.polaris_aws_cnp_artifacts.artifacts.role_keys : []
  assume_role_policy = polaris_aws_cnp_account_trust_policy.trust_policy[each.key].policy
  name_prefix        = "rubrik-${lower(each.key)}-"
  path               = var.aws_role_path
  tags               = var.tags
}

# Create customer managed IAM policies.
resource "aws_iam_policy" "customer_managed" {
  for_each    = local.customer_managed_iam_roles ? local.customer_managed_policies : {}
  name_prefix = "rubrik-${each.key}-"
  path        = var.aws_role_path
  policy      = each.value.policy
  tags        = var.tags
}

# Attach the customer managed IAM policies to the IAM roles.
resource "aws_iam_role_policy_attachment" "customer_managed" {
  for_each   = local.customer_managed_iam_roles ? local.customer_managed_policies : {}
  role       = aws_iam_role.customer_managed[each.value.role_key].name
  policy_arn = aws_iam_policy.customer_managed[each.key].arn
}

# Attach the customer managed IAM policies and the AWS managed IAM policies to
# the IAM roles.
resource "aws_iam_role_policy_attachments_exclusive" "customer_managed" {
  for_each  = local.customer_managed_iam_roles ? data.polaris_aws_cnp_permissions.permissions : {}
  role_name = aws_iam_role.customer_managed[each.key].name

  policy_arns = concat(
    each.value.managed_policies,
    [for policy in each.value.customer_managed_policies : aws_iam_policy.customer_managed[policy.name].arn]
  )
}
