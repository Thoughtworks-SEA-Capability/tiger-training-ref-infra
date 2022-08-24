locals {
  dependency_prefix = "${var.team_name}-${var.environment}"
}
data "aws_ssm_parameter" "eks_master_subnets" {
  name = "${var.team_name}-${var.environment}-eks-master-subnets"
}

data "aws_ssm_parameter" "eks_node_subnets" {
  name = "${var.team_name}-${var.environment}-eks-node-subnets"
  lifecycle {
    postcondition {
      condition     = can(toset(jsondecode(self.value)))
      error_message = "The value should be a set of subnet ids"
    }
  }
}
data "aws_ssm_parameter" "vpc_id" {
  name = "${local.dependency_prefix}-vpc-id"
}

locals {
  eks_master_subnets = toset(jsondecode(data.aws_ssm_parameter.eks_master_subnets.value))
  eks_node_subnets = toset(jsondecode(data.aws_ssm_parameter.eks_node_subnets.value))
  vpc_id = tostring(data.aws_ssm_parameter.vpc_id.value)
}

