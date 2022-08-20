locals {
  team        = var.team_name
  stack       = "terralith"
  environment = var.environment
  name        = "${local.team}-${local.environment}-${local.stack}"
  tags = {
    team        = local.team
    stack       = local.stack
    environment = local.environment
  }
}
data "aws_availability_zones" "azs" {
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = local.name
  cidr = "10.0.0.0/16"
  tags = merge(local.tags, {
    Name = local.name
  })

  azs            = data.aws_availability_zones.azs.names
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  public_subnet_tags = merge(local.tags, {
    Name = "${local.name}-public"
    type = "public"
  })

  private_subnets = [
    # Private subnets for EKS Control Plane
    "10.0.104.0/24", "10.0.105.0/24", "10.0.106.0/24",
    # Private subnets for EKS Nodes
    "10.0.108.0/23", "10.0.110.0/23", "10.0.112.0/23",
  ]
  private_subnet_tags = merge(local.tags, {
    Name = "${local.name}-private"
    type = "private"
  })

  database_subnets = [
    # Private subnets for EKS Nodes
    "10.0.114.0/26", "10.0.114.64/26", "10.0.114.128/26",
  ]
  database_subnet_tags = merge(local.tags, {
    Name = "${local.name}-db"
    type = "db"
  })


  # One NAT per Az
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

}
locals {
  eks_master_subnets = slice(module.vpc.private_subnets, 0, 3)
  eks_node_subnets   = slice(module.vpc.private_subnets, 3, 6)
}
