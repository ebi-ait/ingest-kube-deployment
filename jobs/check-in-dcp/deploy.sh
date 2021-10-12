#!/usr/bin/env bash

api_url="https://api.ingest.dev.archive.data.humancellatlas.org"

if [ $DEPLOYMENT_STAGE == "prod" ]
then
    api_url="https://api.ingest.archive.data.humancellatlas.org"
elif [ $DEPLOYMENT_STAGE == "staging" ]
then
    api_url="https://api.ingest.staging.archive.data.humancellatlas.org"
fi

source ../../config/environment_$DEPLOYMENT_STAGE

helm upgrade ingest-check-in-dcp .\
        --set baseUrl=$api_url\
        --values ./values.yaml\
        --force --install
