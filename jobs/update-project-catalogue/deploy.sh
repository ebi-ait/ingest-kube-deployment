#!/usr/bin/env bash
source ../../config/environment_$DEPLOYMENT_STAGE

helm upgrade update-project-catalogue .\
        --values ./values.yaml\
        --force --install
