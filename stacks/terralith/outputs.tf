output "cluster_name" {
  value = local.name
}
output "cluster_admin_role_arn" {
  value = module.eks.eks_admin_arn
}
