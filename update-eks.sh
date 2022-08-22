#!/usr/bin/env bash

export TF_VAR_team_name=tiger
cd stacks/terralith

cluster_name=$(terraform output -raw cluster_name)
cluster_admin_role_arn=$(terraform output -raw cluster_admin_role_arn)
aws eks update-kubeconfig \
	--region ap-southeast-1 \
	--name $cluster_name \
	--role-arn $cluster_admin_role_arn
