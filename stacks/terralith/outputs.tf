output "cluster_name" {
  value = local.name
}
output "cluster_admin_role_arn" {
  value = module.iam.eks_admin_arn
}
