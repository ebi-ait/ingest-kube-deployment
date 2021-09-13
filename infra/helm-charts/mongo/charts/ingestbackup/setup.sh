#!/usr/bin/env bash

if [ -z $DEPLOYMENT_STAGE ]; then
    echo "Unspecified DEPLOYMENT_STAGE env variable."
    exit 1
else
    echo "INFO: using deployment stage [${DEPLOYMENT_STAGE}]"
fi

# Get the secret access keys
secret=ingest/${DEPLOYMENT_STAGE}/mongo-backup/s3-access
secret=$(aws --region us-east-1 secretsmanager get-secret-value\
                 --secret-id $secret\
                 --query SecretString\
                 --output text 2> /dev/null)

access_key=$(echo $secret | jq -jr .access_key_id | base64)
secret_access_key=$(echo $secret | jq -jr .access_key_secret| base64)

helm upgrade --wait --install -f config/${DEPLOYMENT_STAGE}.yaml --set secret.aws.accessKey=${access_key},secret.aws.secretAccessKey=${secret_access_key} ingest-backup backup
