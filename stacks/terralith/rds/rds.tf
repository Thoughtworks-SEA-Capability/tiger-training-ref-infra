locals {
  db_name = "${var.name}-app-a-db"
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

  vpc_id                 = var.vpc_id
  create_db_subnet_group = false
  db_subnet_group_name   = var.db_subnet_group_name
  subnets                = var.subnets

  allowed_security_groups = var.allowed_security_groups
  allowed_cidr_blocks     = ["10.0.0.0/20"]

  storage_encrypted   = true
  apply_immediately   = true
  monitoring_interval = 10

  db_parameter_group_name         = aws_db_parameter_group.db.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.db.name

  enabled_cloudwatch_logs_exports = ["postgresql"]

  tags = merge(var.tags, {
    Name = local.db_name
  })
}

resource "aws_db_parameter_group" "db" {
  name   = local.db_name
  family = "aurora-postgresql11"
  tags = merge(var.tags, {
    Name : local.db_name
  })
}

resource "aws_rds_cluster_parameter_group" "db" {
  name   = local.db_name
  family = "aurora-postgresql11"
  tags = merge(var.tags, {
    Name : local.db_name
  })
}
