SHELL!=which bash
deployment-stage = ${DEPLOYMENT_STAGE}
force-refresh = ${FORCE_REFRESH}
ontology=${ONTOLOGY_REF}

# testing env only
ingest-api-tests = ${INGEST_API_TESTS_REF}

# REPLICAS
# ==============
ingest-broker-replicas=${INGEST_BROKER_REPLICAS}
ingest-core-replicas=${INGEST_CORE_REPLICAS}
ingest-exporter-replicas=${INGEST_EXPORTER_REPLICAS}
ingest-staging-manager-replicas=${INGEST_STAGING_MANAGER_REPLICAS}
ingest-state-tracking-replicas=${INGEST_STATE_TRACKING_REPLICAS}
ingest-validator-replicas=${INGEST_VALIDATOR_REPLICAS}
ingest-ui-replicas=${INGEST_UI_REPLICAS}
# ==============

fastq-validator-image = ${FASTQ_VALIDATOR_IMAGE}

# INITIAL IMAGES
# ==============
# Initial images used to bring up a new cluster with the deploy-all command in apps/Makefile
# Note: We should really be using latest tags on all images so that most of these can just be set to latest
REPO_PREFIX=quay.io/ebi-ait/ingest
INGEST_STATE_TRACKING_INITIAL_IMAGE=${REPO_PREFIX}-state-tracking:prod-cc9a8470-13-04-2022.1649843705
INGEST_CORE_INITIAL_IMAGE=${REPO_PREFIX}-core:prod-44bb2c19-17-05-2022.1652776235
INGEST_BROKER_INITIAL_IMAGE=${REPO_PREFIX}-broker:prod-fc8416be-13-04-2022.1649843858
INGEST_EXPORTER_INITIAL_IMAGE=${REPO_PREFIX}-exporter:prod-da280944-16-05-2022.1652700078
INGEST_UI_INITIAL_IMAGE=${REPO_PREFIX}-ui:prod-4ee54f26-17-05-2022.1652776207
INGEST_VALIDATOR_INITIAL_IMAGE=${REPO_PREFIX}-validator:prod-0ec3e066-14-04-2022.1649922784
INGEST_DATA_ARCHIVER_INITIAL_IMAGE=${REPO_PREFIX}-data-archiver:prod-bbf151ee-13-05-2022.1652455898
INGEST_GRAPH_VALIDATOR_INITIAL_IMAGE=${REPO_PREFIX}-graph-validator:prod-f561a563-16-05-2022.1652705176
INGEST_ARCHIVER_INITIAL_IMAGE=${REPO_PREFIX}-archiver:prod-99408806-12-05-2022.1652374288
# ==============

deploy-app-%:
	echo "Deploying $(*) with image tag $(image)"
	$(MAKE) set-context
	helm package $(*)
	@if [ "$(force-refresh)" == TRUE ]; then kubectl delete deployment $(*) --ignore-not-found=true; fi;
	. ../config/environment_$(deployment-stage) && helm upgrade -f $(deployment-stage).yaml $(*) $(*)  --set-string environment=$(deployment-stage),fastqImage=$(fastq-validator-image),image=$(image),replicas=$($(*)-replicas),gitlab_app=$(*),gitlab_env=$(deployment-stage) --wait --install
	rm *.tgz

deploy-all:
	$(MAKE) deploy-secrets
	$(MAKE) deploy-ontology
	$(MAKE) deploy-app-ingest-state-tracking image=${INGEST_STATE_TRACKING_INITIAL_IMAGE}
	$(MAKE) deploy-app-ingest-core image=${INGEST_CORE_INITIAL_IMAGE}
	$(MAKE) deploy-app-ingest-broker image=${INGEST_BROKER_INITIAL_IMAGE}
	$(MAKE) deploy-app-ingest-ui image=${INGEST_UI_INITIAL_IMAGE}
	$(MAKE) deploy-app-ingest-exporter image=${INGEST_EXPORTER_INITIAL_IMAGE}
	$(MAKE) deploy-app-ingest-validator image=${INGEST_VALIDATOR_INITIAL_IMAGE}
	$(MAKE) deploy-app-ingest-data-archiver image=${INGEST_DATA_ARCHIVER_INITIAL_IMAGE}
	$(MAKE) deploy-app-ingest-graph-validator image=${INGEST_GRAPH_VALIDATOR_INITIAL_IMAGE}
	$(MAKE) deploy-app-ingest-archiver image=${INGEST_ARCHIVER_INITIAL_IMAGE}

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
