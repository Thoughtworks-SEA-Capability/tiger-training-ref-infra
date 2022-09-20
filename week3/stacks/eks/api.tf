# Use AWS Parameter Store as a config store to publish the API for networking stack

resource "aws_ssm_parameter" "application_namespace" {
  name  = "${var.team_name}-${var.environment}-application-namespace"
  value = local.application_ns_name
  type  = "String"
}

resource "aws_ssm_parameter" "cluster_primary_security_group_id" {
  name  = "${var.team_name}-${var.environment}-cluster-primary-security-group-id"
  value = module.eks.cluster_primary_security_group_id
  type  = "String"
}

resource "aws_ssm_parameter" "eks_cluster_id" {
  name  = "${var.team_name}-${var.environment}-eks-cluster-id"
  type  = "String"
  value = module.eks.cluster_id
}

resource "aws_ssm_parameter" "cluster_admin_role" {
  name  = "${var.team_name}-${var.environment}-cluster-admin-role"
  value = aws_iam_role.eks-admin.arn
  type  = "String"
}

