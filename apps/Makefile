SHELL!=which bash
deployment-stage = ${DEPLOYMENT_STAGE}
force-refresh = ${FORCE_REFRESH}
ingest-broker = ${INGEST_BROKER_REF}
ingest-core = ${INGEST_CORE_REF}
ingest-exporter = ${INGEST_EXPORTER_REF}
ontology = ${ONTOLOGY_REF}
ingest-staging-manager = ${INGEST_STAGING_MANAGER_REF}
ingest-state-tracking= ${INGEST_STATE_TRACKING_REF}
ingest-validator = ${INGEST_VALIDATOR_REF}
ingest-ui = ${INGEST_UI_REF}

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
	$(MAKE) set-context
	helm package $(*)
	@if [ "$(force-refresh)" == TRUE ]; then kubectl delete deployment $(*) --ignore-not-found=true; fi;
	. ../config/environment_$(deployment-stage) && helm upgrade -f $(deployment-stage).yaml $(*) $(*)  --set-string environment=$(deployment-stage),fastqImage=$(fastq-validator-image),image=$($(*)),replicas=$($(*)-replicas) --force --recreate-pods --wait --install
	rm *.tgz

deploy-secrets:
	$(MAKE) set-context
	./scripts/deploy_secrets


deploy-all-apps:
	$(MAKE) set-context
	$(MAKE) deploy-app-ingest-state-tracking
	$(MAKE) deploy-app-ingest-broker
	$(MAKE) deploy-app-ingest-core
	$(MAKE) deploy-app-ontology
	$(MAKE) deploy-app-ingest-validator
	$(MAKE) deploy-app-ingest-ui

deploy-all:
	$(MAKE) set-context
	$(MAKE) deploy-secrets
	$(MAKE) deploy-all-apps

set-context:
	kubectx ingest-eks-$(deployment-stage)
	kubens $(deployment-stage)-environment
