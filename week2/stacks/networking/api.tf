# Use AWS Parameter Store as a config store to publish the API for networking stack
locals {
  parameter_prefix = "${var.team_name}-${var.environment}"
}

# Dependencies for stacks creating EKS
resource "aws_ssm_parameter" "eks_master_subnets" {
  name  = "${var.team_name}-${var.environment}-eks-master-subnets"
  value = jsonencode(slice(module.vpc.private_subnets,0,3))
  type  = "String"
}

resource "aws_ssm_parameter" "eks_node_subnets" {
  name  = "${var.team_name}-${var.environment}-eks-node-subnets"
  value = jsonencode(slice(module.vpc.private_subnets,6,9))
  type  = "String"
}

resource "aws_ssm_parameter" "vpc_id" {
  name  = "${var.team_name}-${var.environment}-vpc-id"
  type  = "String"
  value = module.vpc.vpc_id
}

# Dependencies for stacks creating application database
resource "aws_ssm_parameter" "database_subnets" {
  name  = "${var.team_name}-${var.environment}-database-subnets"
  type  = "String"
  value = jsonencode(module.vpc.database_subnets)
}

resource "aws_ssm_parameter" "database_subnet_group_name" {
  name  = "${local.parameter_prefix}-database-subnet-group-name"
  type  = "String"
  value = module.vpc.database_subnet_group_name
}
