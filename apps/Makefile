SHELL!=which bash
deployment-stage = ${DEPLOYMENT_STAGE}
force-refresh = ${FORCE_REFRESH}
ontology=${ONTOLOGY_REF}

# testing env only
ingest-api-tests = ${INGEST_API_TESTS_REF}

# REPLICAS
ingest-broker-replicas=${INGEST_BROKER_REPLICAS}
ingest-core-replicas=${INGEST_CORE_REPLICAS}
ingest-exporter-replicas=${INGEST_EXPORTER_REPLICAS}
ingest-staging-manager-replicas=${INGEST_STAGING_MANAGER_REPLICAS}
ingest-state-tracking-replicas=${INGEST_STATE_TRACKING_REPLICAS}
ingest-validator-replicas=${INGEST_VALIDATOR_REPLICAS}
ingest-ui-replicas=${INGEST_UI_REPLICAS}

fastq-validator-image = ${FASTQ_VALIDATOR_IMAGE}

deploy-app-%:
	echo "Deploying $(*) with image tag $(image)"
	$(MAKE) set-context
	helm package $(*)
	@if [ "$(force-refresh)" == TRUE ]; then kubectl delete deployment $(*) --ignore-not-found=true; fi;
	. ../config/environment_$(deployment-stage) && helm upgrade -f $(deployment-stage).yaml $(*) $(*)  --set-string environment=$(deployment-stage),fastqImage=$(fastq-validator-image),image=$(image),replicas=$($(*)-replicas),gitlab_app=$(*),gitlab_env=$(deployment-stage) --force --wait --install
	rm *.tgz

deploy-ontology:
	$(MAKE) deploy-app-ontology image=$(ontology)

rollout-%:
	echo "Rolling out $(*) with image tag $(image)"
	$(MAKE) set-context
	helm package $(*)
	@if [ "$(force-refresh)" == TRUE ]; then kubectl delete deployment $(*) --ignore-not-found=true; fi;
	. ../config/environment_$(deployment-stage) && helm upgrade -f $(deployment-stage).yaml $(*) $(*)  --set-string environment=$(deployment-stage),fastqImage=$(fastq-validator-image),image=$(image),replicas=$($(*)-replicas),gitlab_app=$(*),gitlab_env=$(deployment-stage) --wait --install
	rm *.tgz

rollout-ontology:
	$(MAKE) deploy-app-ontology image=$(ontology)

deploy-secrets:
	$(MAKE) set-context
	./scripts/deploy_secrets

set-context:
	kubectx ingest-eks-$(deployment-stage)
	kubens $(deployment-stage)-environment
