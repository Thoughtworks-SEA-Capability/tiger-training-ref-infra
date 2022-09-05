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

### Import missing state from exisitng resoruces
# terraform import module.vpc.aws_subnet.private[6] subnet-07a98cb194ba286b0
# terraform import module.vpc.aws_subnet.private[7] subnet-0e3b045594f0bb2f5

# tf-smv module.vpc.aws_subnet.private[3] aws_subnet.tmp[0]
# tf-smv module.vpc.aws_subnet.private[4] aws_subnet.tmp[1]
# tf-smv module.vpc.aws_subnet.private[5] aws_subnet.tmp[2]

# tf-smv module.vpc.aws_subnet.private[6] module.vpc.aws_subnet.private[3]
# tf-smv module.vpc.aws_subnet.private[7] module.vpc.aws_subnet.private[4]
# tf-smv module.vpc.aws_subnet.private[8] module.vpc.aws_subnet.private[5]

tf-smv aws_subnet.tmp[0] module.vpc.aws_subnet.private[6]
tf-smv aws_subnet.tmp[1] module.vpc.aws_subnet.private[7]
tf-smv aws_subnet.tmp[2] module.vpc.aws_subnet.private[8]

terraform show -json | jq '.values.root_module.child_modules[].resources[] | select(.address | startswith("module.vpc.aws_subnet")) | .index, .values.cidr_block'
