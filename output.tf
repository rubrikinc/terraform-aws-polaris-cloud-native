output "rsc_aws_cnp_account_id" {
  value = polaris_aws_cnp_account.account.id
}

output "cluster_master_role_arn" {
  value = aws_iam_role.rsc_roles["EXOCOMPUTE_EKS_MASTERNODE"].arn
}

output "worker_instance_profile" {
  value = aws_iam_instance_profile.profile["EXOCOMPUTE_EKS_WORKERNODE"].name
}

output "aws_iam_cross_account_role_arn" {
  value = aws_iam_role.rsc_roles["CROSSACCOUNT"].arn
}

output "aws_eks_worker_node_role_arn" {
  value = aws_iam_role.rsc_roles["EXOCOMPUTE_EKS_WORKERNODE"].arn
}