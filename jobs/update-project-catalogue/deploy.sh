#!/usr/bin/env bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source $SCRIPT_DIR/../../config/environment_$DEPLOYMENT_STAGE

helm upgrade update-project-catalogue .\
        --values ./values.yaml\
        --force --install
