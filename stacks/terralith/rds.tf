locals {
  db_name = "${local.name}-app-a-db"
}
module "cluster" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "7.2.1"

  name           = local.db_name
  engine         = "aurora-postgresql"
  engine_version = "11.12"
  instance_class = "db.t3.medium"
  instances = {
    one = {}
  }

  vpc_id  = module.vpc.vpc_id
  create_db_subnet_group = false
  db_subnet_group_name = module.vpc.database_subnet_group_name
  subnets = module.vpc.database_subnets

  allowed_security_groups = [module.eks.cluster_primary_security_group_id]
  allowed_cidr_blocks     = ["10.0.0.0/20"]

  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10

  db_parameter_group_name         = aws_db_parameter_group.db.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.db.name

  enabled_cloudwatch_logs_exports = ["postgresql"]

  tags = merge(local.tags,{
    Name = local.db_name
  } )
}

resource "aws_db_parameter_group" "db" {
  name = local.db_name
  family = "aurora-postgresql11"
  tags = merge(local.tags, {
    Name: local.db_name
  })
}

resource "aws_rds_cluster_parameter_group" "db" {
  name = local.db_name
  family = "aurora-postgresql11"
  tags = merge(local.tags, {
    Name: local.db_name
  })
}

// This secret name is sort of like config store for infra to pass on data to the application layer
// The name is agreed on by convention, changing the name will break the test and whatever subsequent applications
resource "kubernetes_secret_v1" "app-a-rds-creds" {
  metadata {
    name = "app-a-db"
    namespace = local.application-ns-name
  }
  data = {
    db_name = module.cluster.cluster_database_name,
    db_endpoint = module.cluster.cluster_endpoint,
    db_username = module.cluster.cluster_master_username,
    db_password = module.cluster.cluster_master_password,
  }
}
