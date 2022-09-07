TF_VAR_team_name=tiger
TF_VAR_change_ci_created_stack_from_local=true
TF_PATH=stacks
STACK=networking
ENV=stg

ENV_VAR=TF_VAR_team_name=${TF_VAR_team_name} TF_VAR_change_ci_created_stack_from_local=${TF_VAR_change_ci_created_stack_from_local}


# make init STACK=eks ENV=stg
init:
	terraform -chdir=${TF_PATH}/${STACK} init -backend-config="key=${TF_VAR_team_name}/${ENV}/${STACK}" -reconfigure

plan: init
	${ENV_VAR} terraform -chdir=${TF_PATH}/${STACK} plan -var-file=./../../environments/${STACK}/${ENV}.tfvars

apply: init
	${ENV_VAR} terraform -chdir=${TF_PATH}/${STACK} apply -var-file=./../../environments/${STACK}/${ENV}.tfvars

console: init
	${ENV_VAR} terraform -chdir=${TF_PATH}/${STACK} console -var-file=./../../environments/${STACK}/${ENV}.tfvars

destroy: init
	${ENV_VAR} terraform -chdir=${TF_PATH}/${STACK} destroy -var-file=./../../environments/${STACK}/${ENV}.tfvars

destroy-all:
	# week2 - app-a
	terraform -chdir=${TF_PATH}/app-a init -backend-config="key=${TF_VAR_team_name}/stg/app-a" -reconfigure
	${ENV_VAR} terraform -chdir=${TF_PATH}/app-a destroy -var-file=./../../environments/app-a/stg.tfvars

	# week2 - eks
	terraform -chdir=${TF_PATH}/eks init -backend-config="key=${TF_VAR_team_name}/stg/eks" -reconfigure
	${ENV_VAR} terraform -chdir=${TF_PATH}/eks destroy -var-file=./../../environments/eks/stg.tfvars

	# week2 - networking
	terraform -chdir=${TF_PATH}/networking init -backend-config="key=${TF_VAR_team_name}/stg/networking" -reconfigure
	${ENV_VAR} terraform -chdir=${TF_PATH}/networking destroy -var-file=./../../environments/networking/stg.tfvars

	# week1
	# terraform -chdir=${TF_PATH} destroy --var-file=dev.tfvars

fmt:
	terraform -chdir=${TF_PATH} fmt -recursive
	terraform -chdir=${TF_PATH}/${STACK} fmt -recursive

validate:
	terraform -chdir=${TF_PATH}/${STACK} validate

test:
	cd tests && go test -v

update-eks:
	./update-eks.sh
