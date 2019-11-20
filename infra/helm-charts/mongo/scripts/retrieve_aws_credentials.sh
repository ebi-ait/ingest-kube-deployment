#! /usr/bin/env sh

access_key_id=$(aws secretsmanager get-secret-value --secret-id dcp/ingest/dev/mongo-backup/s3-access  --region=us-east-1 | jq -r .SecretString| jq -r .access_key_id)
access_key_secret=$(aws secretsmanager get-secret-value --secret-id dcp/ingest/dev/mongo-backup/s3-access  --region=us-east-1 | jq -r .SecretString| jq -r .access_key_secret)

echo $access_key_id
echo $access_key_secret
