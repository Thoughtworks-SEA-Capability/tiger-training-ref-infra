# Use AWS Parameter Store as a config store to publish the API for networking stack

resource "aws_ssm_parameter" "eks_master_subnets" {
  name  = "${var.team_name}-${var.environment}-eks-master-subnets"
  value = jsonencode(slice(module.vpc.private_subnets,0,3))
  type  = "String"
}

resource "aws_ssm_parameter" "eks_node_subnets" {
  name  = "${var.team_name}-${var.environment}-eks-node-subnets"
  value = jsonencode(slice(module.vpc.private_subnets,3,6))
  type  = "String"
}
