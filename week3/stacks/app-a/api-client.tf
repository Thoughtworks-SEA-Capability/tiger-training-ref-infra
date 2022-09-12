locals {
  dependency_prefix = "${var.team_name}-${var.environment}"
}

data "aws_ssm_parameter" "application_namespace" {
  name = "${local.dependency_prefix}-application-namespace"
}

data "aws_ssm_parameter" "vpc_id" {
  name = "${local.dependency_prefix}-vpc-id"
}

data "aws_ssm_parameter" "database_subnets" {
  name = "${local.dependency_prefix}-database-subnets"
}

data "aws_ssm_parameter" "database_subnet_group_name" {
  name = "${local.dependency_prefix}-database-subnet-group-name"
}

data "aws_ssm_parameter" "cluster_primary_security_group_id" {
  name = "${local.dependency_prefix}-cluster-primary-security-group-id"
}
data "aws_ssm_parameter" "eks_cluster_id" {
  name = "${local.dependency_prefix}-eks-cluster-id"
}
data "aws_ssm_parameter" "eks_admin_role" {
  name = "${local.dependency_prefix}-cluster-admin-role"
}
locals {
  eks_admin_role                    = data.aws_ssm_parameter.eks_admin_role.value
  application_namespace             = tostring(data.aws_ssm_parameter.application_namespace.value)
  cluster_primary_security_group_id = data.aws_ssm_parameter.cluster_primary_security_group_id.value
  database_subnets                  = toset(jsondecode(data.aws_ssm_parameter.database_subnets.value))
  database_subnet_group_name        = data.aws_ssm_parameter.database_subnet_group_name.value
  eks_cluster_id                    = data.aws_ssm_parameter.eks_cluster_id.value
  vpc_id                            = data.aws_ssm_parameter.vpc_id.value
}
