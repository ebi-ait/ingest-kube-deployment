SHELL!=which bash
deployment-stage = ${DEPLOYMENT_STAGE}
force-refresh = ${FORCE_REFRESH}
ontology = ${ONTOLOGY_REF}

# testing env only
ingest-api-tests = ${INGEST_API_TESTS_REF}

# REPLICAS
fastq-validator-image = ${FASTQ_VALIDATOR_IMAGE}

deploy-app-ontology:
	$(MAKE) set-context
	helm package ontology
	@if [ "$(force-refresh)" == TRUE ]; then kubectl delete deployment ontology --ignore-not-found=true; fi;
	. ../config/environment_$(deployment-stage) && helm upgrade -f $(deployment-stage).yaml ontology ontology  --set-string environment=$(deployment-stage),fastqImage=$(fastq-validator-image),image=$(ontology),replicas=1 --force --wait --install
	rm *.tgz

rollout-ontology:
	$(MAKE) set-context
	helm package ontology
	@if [ "$(force-refresh)" == TRUE ]; then kubectl delete deployment ontology --ignore-not-found=true; fi;
	. ../config/environment_$(deployment-stage) && helm upgrade -f $(deployment-stage).yaml ontology ontology  --set-string environment=$(deployment-stage),fastqImage=$(fastq-validator-image),image=$(ontology),replicas=1 --wait --install
	rm *.tgz

deploy-secrets:
	$(MAKE) set-context
	./scripts/deploy_secrets

set-context:
	kubectx ingest-eks-$(deployment-stage)
	kubens $(deployment-stage)-environment
