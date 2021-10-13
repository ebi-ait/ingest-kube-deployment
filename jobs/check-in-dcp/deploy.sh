#!/usr/bin/env bash
source ../../config/environment_$DEPLOYMENT_STAGE

helm upgrade ingest-check-in-dcp .\
        --values ./values.yaml\
        --force --install
