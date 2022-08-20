module "rds" {
  source = "./rds"

  name                 = local.name
  vpc_id               = module.vpc.vpc_id
  db_subnet_group_name = module.vpc.database_subnet_group_name
  subnets              = module.vpc.database_subnets

  allowed_security_groups = [module.eks.cluster_primary_security_group_id]
  tags                    = local.tags
}

// This secret name is sort of like config store for infra to pass on data to the application layer
// The name is agreed on by convention, changing the name will break the test and whatever subsequent application
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
