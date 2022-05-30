#! /usr/bin/env sh

deployment_stage=$1

s3_access_secrets=$(aws secretsmanager get-secret-value --secret-id ingest/${deployment_stage}/mongo-backup/s3-access  --region=us-east-1 | jq -r .SecretString)

access_key_id=$(echo ${s3_access_secrets} | jq -jr .access_key_id | base64)
access_key_secret=$(echo ${s3_access_secrets} | jq -jr .access_key_secret| base64)
slack_alert_webhook=$(aws secretsmanager get-secret-value --secret-id ingest/${deployment_stage}/alerts  --region=us-east-1 | jq -r .SecretString | jq -r .webhook_url)

helm package .

. ../../../config/environment_${deployment_stage}

helm upgrade mongo ./ --wait --install --force -f values.yaml \
    --set ingestbackup.secret.aws.accessKey=${access_key_id},ingestbackup.secret.aws.secretAccessKey=${access_key_secret},ingestbackup.verification.slack.webhookUrl=${slack_alert_webhook} \
    --set ingestbackup.aws.s3.directory=${deployment_stage}

rm *.tgz
