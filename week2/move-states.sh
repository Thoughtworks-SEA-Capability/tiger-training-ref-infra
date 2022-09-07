#!/usr/bin/env bash

export TF_VAR_team_name=tiger
export TF_VAR_environment=stg
export STACK=networking
export ENV=stg
cd stacks/networking

function tf-smv {
	terraform state mv $@
}

function tf-smvb {
	terraform state mv $2 $1 #roll back
}

terraform show -json | jq '.values.root_module.child_modules[].resources[] | select(.address | startswith("module.vpc.aws_subnet")) | .index, .values.cidr_block'

tf-smv module.vpc.aws_subnet.private[6] module.vpc.aws_subnet.private[3]
tf-smv module.vpc.aws_subnet.private[7] module.vpc.aws_subnet.private[4]
tf-smv module.vpc.aws_subnet.private[8] module.vpc.aws_subnet.private[5]

tf-smv module.vpc.aws_route_table_association.private[6] module.vpc.aws_route_table_association.private[3]
tf-smv module.vpc.aws_route_table_association.private[7] module.vpc.aws_route_table_association.private[4]
tf-smv module.vpc.aws_route_table_association.private[8] module.vpc.aws_route_table_association.private[5]

terraform show -json | jq '.values.root_module.child_modules[].resources[] | select(.address | startswith("module.vpc.aws_subnet")) | .index, .values.cidr_block'
