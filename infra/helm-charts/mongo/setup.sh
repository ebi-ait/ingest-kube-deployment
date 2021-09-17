#! /usr/bin/env sh

if [ -z $DEPLOYMENT_STAGE ]; then
    echo "Unspecified DEPLOYMENT_STAGE env variable."
    exit 1
else
    echo "INFO: using deployment stage [${DEPLOYMENT_STAGE}]"
fi

secret=ingest/${DEPLOYMENT_STAGE}/mongo-backup/s3-access
secret=$(aws --region us-east-1 secretsmanager get-secret-value\
                 --secret-id $secret\
                 --query SecretString\
                 --output text 2> /dev/null)

access_key_id=$(echo $secret | jq -jr .access_key_id | base64 --decode)
access_key_secret=$(echo $secret | jq -jr .access_key_secret| base64 --decode)

# slack_alert_webhook=$(aws secretsmanager get-secret-value --secret-id ingest/${DEPLOYMENT_STAGE}/alerts  --region=us-east-1 | jq -r .SecretString | jq -r .webhook_url)

helm package .

# . ../../../config/environment_${DEPLOYMENT_STAGE}

helm upgrade mongo ./ --wait --install --force -f values.yaml -f environments/${DEPLOYMENT_STAGE}.yaml --set ingestbackup.secret.aws.secretAccessKey=${access_key_secret},ingestbackup.verification.slack.webhookUrl=${slack_alert_webhook}

rm *.tgz
