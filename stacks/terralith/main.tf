# module "iam" {
#   source = "./iam"

#   name = local.name
# }

data "aws_eks_cluster" "default" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.default.token
}

module "eks" {
  source = "./eks"

  name = local.name
  vpc_id = module.vpc.vpc_id
  eks_master_subnets = slice(module.vpc.private_subnets,0,3)
  # eks_admin_arn = module.iam.eks_admin_arn
  application_ns_name = local.application-ns-name

  tags = local.tags
}

module "rds" {
  source = "./rds"

  name                 = local.name
  vpc_id               = module.vpc.vpc_id
  db_subnet_group_name = module.vpc.database_subnet_group_name
  subnets              = module.vpc.database_subnets

  allowed_security_groups = [module.eks.cluster_primary_security_group_id]
  tags                    = local.tags
}

resource "kubernetes_secret_v1" "app-a-rds-creds" {
  metadata {
    name      = "app-a-db"
    namespace = local.application-ns-name
  }
  data = {
    db_name     = module.rds.cluster_database_name,
    db_endpoint = module.rds.cluster_endpoint,
    db_username = module.rds.cluster_master_username,
    db_password = module.rds.cluster_master_password,
  }
}

locals {
  application-ns-name = "application"
}
