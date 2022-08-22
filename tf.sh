#!/usr/bin/env bash

export TF_VAR_team_name=tiger
cd stacks/terralith
terraform init -backend-config="key=${TF_VAR_team_name}/dev/terralith"
# terraform plan --var-file=dev.tfvars
# terraform apply --var-file=dev.tfvars

# cluster_name=$(terraform output -raw cluster_name)
# cluster_admin_role_arn=$(terraform output -raw cluster_admin_role_arn)
# echo $cluster_name
# echo $cluster_admin_role_arn
# aws eks update-kubeconfig \
#     --region ap-southeast-1 \
#     --name $cluster_name \
#     --role-arn $cluster_admin_role_arn

# cd ../../tests
# go test

terraform destroy --var-file=dev.tfvars
