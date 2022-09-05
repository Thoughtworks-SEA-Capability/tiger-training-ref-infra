TF_VAR_team_name=tiger
TF_PATH=stacks/terralith
TF_PATH_W2=week2/stacks

init:
	terraform -chdir=${TF_PATH} init -backend-config="key=${TF_VAR_team_name}/dev/terralith"

plan: init
	terraform -chdir=${TF_PATH} init --var-file=dev.tfvars

apply: init
	terraform -chdir=${TF_PATH} apply --var-file=dev.tfvars

destroy:
	# week2 - app-a
	terraform -chdir=${TF_PATH_W2}/app-a init -backend-config="key=${TF_VAR_team_name}/stg/app-a" -reconfigure
	terraform -chdir=${TF_PATH_W2}/app-a destroy -var-file=../../environments/app-a/stg.tfvars
	# week2 - eks
	terraform -chdir=${TF_PATH_W2}/eks init -backend-config="key=${TF_VAR_team_name}/stg/eks" -reconfigure
	terraform -chdir=${TF_PATH_W2}/eks destroy -var-file=../../environments/eks/stg.tfvars
	# week2 - networking
	terraform -chdir=${TF_PATH_W2}/networking init -backend-config="key=${TF_VAR_team_name}/stg/networking" -reconfigure
	terraform -chdir=${TF_PATH_W2}/networking destroy -var-file=../../environments/networking/stg.tfvars

	# week1
	# terraform -chdir=${TF_PATH} destroy --var-file=dev.tfvars

fmt:
	terraform -chdir=${TF_PATH} fmt -recursive

validate:
	terraform -chdir=${TF_PATH} validate

test:
	cd week2/tests && go test 

update-eks:
	./update-eks.sh
