TF_VAR_team_name=tiger
TF_PATH=stacks/terralith

init:
	terraform -chdir=${TF_PATH} init -backend-config="key=${TF_VAR_team_name}/dev/terralith"

plan: init
	terraform -chdir=${TF_PATH} init --var-file=dev.tfvars

apply: init
	terraform -chdir=${TF_PATH} apply --var-file=dev.tfvars

destroy:
	terraform -chdir=${TF_PATH} destroy --var-file=dev.tfvars

fmt:
	terraform -chdir=${TF_PATH} fmt -recursive

validate:
	terraform -chdir=${TF_PATH} validate

test:
	cd tests && go test 

update-eks:
	./update-eks.sh
