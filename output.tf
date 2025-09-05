output "rsc_aws_cnp_account_id" {
  value = polaris_aws_cnp_account.account.id
}

output "cluster_master_role_arn" {
  value = try(local.roles["EXOCOMPUTE_EKS_MASTERNODE"].arn, null)
}

output "worker_instance_profile" {
  value = try(aws_iam_instance_profile.profile["EXOCOMPUTE_EKS_WORKERNODE"].name, null)
}

output "aws_iam_cross_account_role_arn" {
  value = local.roles["CROSSACCOUNT"].arn
}

output "aws_eks_worker_node_role_arn" {
  value = try(local.roles["EXOCOMPUTE_EKS_WORKERNODE"].arn, null)
}
