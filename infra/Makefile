SHELL!=which bash
deployment_stage = ${DEPLOYMENT_STAGE}
kubeconfig_path=${KUBECONFIG_PATH}

create-cluster-%:
	# Add User confirmation of action and environment here and then apply -auto-confirm flag on terraform
	# This step is idempotent and can be run again if the cluster needs to be modified.
	$(MAKE) init-$(*)
	. scripts/generate_ssh_keys && terraform apply
	$(MAKE) retrieve-kubeconfig-$(*)
	$(MAKE) apply-dashboard-configs-$(*)
	$(MAKE) deploy-backend-services-$(*)

deploy-backend-services-%:
	# Add User confirmation of action and environment here and then apply -auto-confirm flag on terraform
	$(MAKE) set-context-$(*)
	$(MAKE) setup-retained-storage-$(*)
	$(MAKE) install-infra-helm-chart-mongo
	$(MAKE) install-infra-helm-chart-rabbit
	$(MAKE) install-infra-helm-chart-redis
	$(MAKE) setup-ingress-$(*)

modify-cluster-%:
	# Add User confirmation of environment and action here and then apply -auto-confirm flag on terraform
	$(MAKE) init-$(*)
	. scripts/generate_ssh_keys && terraform apply

destroy-cluster-%:
	# Add User confirmation of action here and then apply -auto-confirm flag on terraform
	$(MAKE) init-$(*)
	$(MAKE) set-context-$(*)
	helm ls --all --short | xargs -L1 helm uninstall
	terraform destroy
	$(MAKE) delete-kubeconfig-(*)

retrieve-kubeconfig-%:
	# delete exissting env config in ./kube/config before retrieving new config
	$(MAKE) delete-kubeconfig-$(*)
	# confirm environment here and then apply -auto-confirm flag on terraform
	$(MAKE) init-$(*)
	mkdir -p ../config/cluster-secrets/ $(*)
	terraform output kubeconfig > ../config/cluster-secrets/kubeconfig_$(*)
	KUBECONFIG=~/.kube/config:$(kubeconfig_path) kubectl config view --flatten > mergedkub && mv mergedkub ~/.kube/config
	terraform output namespace > $(*)/namespace.yaml
	kubectx ingest-eks-$(*)
	kubectl apply -f $(*)/namespace.yaml
	rm -rf $(*)
	$(MAKE) set-context-$(*)
	$(MAKE) apply-env-configs-$(*)

delete-kubeconfig-%:
	-kubectl config delete-cluster ingest-eks-$(*)
	-kubectl config delete-context ingest-eks-$(*)
	kubectl config unset users.ingest-eks-$(*)

# keeping this for reference
unset-config-%:
	kubectl config unset users.ingest-eks-$(*)
	kubectl config unset contexts.ingest-eks-$(*)
	kubectl config unset clusters.ingest-eks-$(*)

setup-dashboard-%:
	kubectx ingest-eks-$(*)
	kubens $(*)-environment
	kubectl proxy

apply-env-configs-%:
	# confirm environment here
	$(MAKE) init-$(*)
	$(MAKE) set-context-$(*)
	rm -rf $(*)
	mkdir -p $(*)
	terraform output config_map > $(*)/config_map.yaml
	kubectl apply -f $(*)/config_map.yaml
	rm -rf $(*)

install-infra-helm-chart-mongo:
	cd helm-charts/mongo && ./setup.sh $(deployment_stage)

install-infra-helm-chart-%:
	cd helm-charts && helm dependency update $(*) && helm package $(*)
	. ../config/environment_$(deployment_stage) && cd helm-charts && helm upgrade --values $(*)/values.yaml --values $(*)/environments/$(deployment_stage).yaml $(*) ./$(*) --force --install
	cd helm-charts && rm *.tgz

apply-dashboard-configs-%:
	# confirm environment here
	$(MAKE) set-context-$(*)
	. ../config/environment_$(*) && kubectl apply -f dashboard-configs/

setup-ingress-%:
	$(MAKE) set-context-$(*)
	cd helm-charts && helm dependency update ingress
	cd helm-charts && helm upgrade -f ingress/values.yaml --values ingress/environments/$(*).yaml ingress ./ingress --force --install

setup-retained-storage-%:
	$(MAKE) set-context-$(*)
	cd helm-charts && helm dependency update retained-fs-storage
	cd helm-charts && helm upgrade retained-fs-storage ./retained-fs-storage --force --wait --install

init-%:
	# confirm environment here
	rm -rf .terraform
	. ../config/environment_$(*) && . scripts/init.sh

set-context-%:
	kubectx ingest-eks-$(*)
	kubens $(*)-environment
