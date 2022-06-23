#!/bin/bash
set -e

# automation script derived from the [HCAO Release SOP](https://github.com/ebi-ait/hca-ebi-dev-team/blob/3d46d026d54f176149e28b3d47eebf78f1d5478c/docs/operations_tasks/HCAO-release.md)
# expected to be run from the ./infra directory
DEPLOYMENT_STAGE=dev
ONTOLOGY_VERSION=
GITLAB_URL=https://gitlab.ebi.ac.uk
while getopts e:v: flag
do
    case "${flag}" in
        e) DEPLOYMENT_STAGE=${OPTARG};;
        v) ONTOLOGY_VERSION=${OPTARG};;
        g) GITLAB_TOKEN=${OPTARG};;
    esac
done

# ANSI colors for clear log messages
GRN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${GRN}deployment of ontology $ONTOLOGY_VERSION on $DEPLOYMENT_STAGE started${NC}"

echo "verifying version ${ONTOLOGY_VERSION} in quay.io"
curl https://quay.io/api/v1/repository/ebi-ait/ontology/tag/ | jq -e ".tags[] | select(.name==\"${ONTOLOGY_VERSION}\")"

echo -e "${GRN}updating environment config files${NC}"
sed -i.bak \
  "s/ONTOLOGY_REF=.*/ONTOLOGY_REF=${ONTOLOGY_VERSION}/" \
  ../config/environment_${DEPLOYMENT_STAGE}

echo -e "${GRN}load environment configuration${NC}"
source ../config/environment_${DEPLOYMENT_STAGE}

echo -e "${GRN}change k8s cluster${NC}"
kubectx ingest-eks-${DEPLOYMENT_STAGE}


echo -e "${GRN}deploy ontology service${NC}"
cd ../apps
make deploy-ontology
cd -

echo -e "${GRN}redeploy ingest-validator to clear ontology cache${NC}"
kubectl rollout restart deployment ingest-validator

echo -e "${GRN}verify the correct image has been deployed${NC}"
kubectl get deployment ontology -o yaml | grep image | grep ${ONTOLOGY_VERSION}

echo update release notes

changelog_file=../${DEPLOYMENT_STAGE}/changelog.md
if [[ $DEPLOYMENT_STAGE == "prod" ]]
then
    changelog_file=../production/changelog.md
fi

version_notes_file=version.txt.tmp
cat << __VERSION_DESC > ${version_notes_file}
## $(date '+%d %B %Y')
- Ontology ${ONTOLOGY_VERSION}
  - HCA Ontology Release-${ONTOLOGY_VERSION}
- Validator $(kubectl get deployment ingest-validator -o jsonpath --template '{.spec.template.spec.containers[0].image}')
  - no version change, redeployed to clear ontology cache

__VERSION_DESC

if [[ $DEPLOYMENT_STAGE != "dev" ]]
then
  sed -i.bak "2r ${version_notes_file}" ${changelog_file}
  git add ${changelog_file}
fi

echo -e "${GRN}Commit and push your config and release notes${NC}"

git add ../config/environment_${DEPLOYMENT_STAGE}

git commit -m "install HCA ontology ${ONTOLOGY_VERSION}"

if [[ "${GITLAB_TOKEN}" != "" ]]
then
  echo -e "${GRN}running integration tests${NC}"
  GITLAB_PROJECT_ID=$(curl --location --request GET "${GITLAB_URL}/api/v4/projects?search=ingest-integration-tests" --header "PRIVATE-TOKEN: $GITLAB_TOKEN" | jq ".[] | .id")
  curl --request POST \
       --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
       "${GITLAB_URL}/api/v4/projects/${GITLAB_PROJECT_ID}/pipeline?ref=${DEPLOYMENT_STAGE}"
  echo -e "${GRN}check results on gitlab: ${GITLAB_URL}/hca/ingest-integration-tests/-/pipelines${NC}"
else
  echo -e "${GRN}run integration tests on gitlab: ${GITLAB_URL}/hca/ingest-integration-tests/-/pipelines${NC}"
fi

echo -e "${GRN}deployment of ontology $ONTOLOGY_VERSION on $DEPLOYMENT_STAGE is complete${NC}"
