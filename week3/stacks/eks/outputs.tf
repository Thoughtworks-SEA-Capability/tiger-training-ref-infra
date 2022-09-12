output "cluster_name" {
  value = local.name
}
output "cluster_admin_role_arn" {
  value = aws_iam_role.eks-admin.arn
}


