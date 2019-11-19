#!/usr/bin/env bash

if [[ -z $1 ]]; then
    echo "No schedule specified."
    exit 1
fi


patch='{ "spec": { "schedule": "'"$@"'" } }'
kubectl patch cronjob ingest-backup -p "$patch"


