#!/bin/bash

set -vxe

# automation script derived from the [HCAO Release SOP](https://github.com/ebi-ait/hca-ebi-dev-team/blob/3d46d026d54f176149e28b3d47eebf78f1d5478c/docs/operations_tasks/HCAO-release.md)
# expected to be run from the ./infra directory
DEPLOYMENT_STAGE=dev
ONTOLOGY_VERSION=1.0.38

echo "verifying version ${ONTOLOGY_VERSION}" in quay.io
curl https://quay.io/api/v1/repository/ebi-ait/ontology/tag/ | jq -e ".tags[] | select(.name==\"${ONTOLOGY_VERSION}\")"

echo "updating environment config files"
sed -i.bak \
  "s/ONTOLOGY_REF=.*/ONTOLOGY_REF=${ONTOLOGY_VERSION}/" \
  ../config/environment_{dev,staging,prod,integration}

echo "load environment configuration"
source ../config/environment_${DEPLOYMENT_STAGE}

echo "change k8s cluster"
kubectx ingest-eks-${DEPLOYMENT_STAGE}

cd ../apps

echo "deploy ontology service"
make deploy-ontology


echo "redeploy ingest-validator to clear ontology cache"
kubectl rollout restart deployment ingest-validator

echo "verify the correct image has been deployed"
kubectl get deployment ontology -o yaml | grep image | grep ${ONTOLOGY_VERSION}

echo update release notes

changelog_file=../${DEPLOYMENT_STAGE}/changelog.md
if [[ $DEPLOYMENT_STAGE == "prod" ]]
then
    changelog_file=../production/changelog.md
fi

cat << __VERSION_DESC > tmp_version.txt
## $(date '+%d %B %Y')
- Ontology ${ONTOLOGY_VERSION}
  - HCA Ontology Release-${ONTOLOGY_VERSION}
- Validator $(kubectl get deployment ingest-validator -o jsonpath --template '{.spec.template.spec.containers[0].image}')
  - no version change, redeployed to clear ontology cache
__VERSION_DESC

if [[ $DEPLOYMENT_STAGE != "dev" ]]
then
  sed '2r version.txt.tmp' ${changelog_file}
  git add ${changelog_file}
fi

echo "Commit and push your config and release notes"

git add ../config/environment_${DEPLOYMENT_STAGE}

git commit -m "install HCA ontology ${ONTOLOGY_VERSION}"