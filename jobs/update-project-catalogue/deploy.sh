#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $SCRIPT_DIR/../../config/environment_$DEPLOYMENT_STAGE

source $SCRIPT_DIR/docker-app/version.sh

helm upgrade update-project-catalogue .\
        --set-string image.repository=$DOCKER_REPO,image.tag=$DOCKER_TAG\
        --values ./values.yaml\
        --force --install
