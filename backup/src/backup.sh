#!/bin/sh

DB_DUMP=/data/db/dump/$(date '+%Y-%m-%dT%H_%M')

# set up AWS role and credentials
if [ -z $AWS_ACCESS_KEY_ID ]; then echo 'Missing access key id'; exit 1; fi
if [ -z $AWS_SECRET_ACCESS_KEY ]; then echo 'Missing secret access key'; exit 1; fi
if [ -z $AWS_ROLE_ARN ]; then echo 'Missing role ARN'; exit 1; fi

aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID
aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY
aws configure set profile.backup.role_arn $AWS_ROLE_ARN
aws configure set profile.backup.source_profile default

mongodump \
--host mongo-service \
--out $DB_DUMP

alias s3backup='aws s3 --profile=backup'

BACKUP_FILE=$DB_DUMP.tar.gz
tar -zcvf $BACKUP_FILE $DB_DUMP

if [ -z "$S3_BUCKET" ]; then
    echo "S3 Bucket not specified!"
    rm $BACKUP_FILE
    exit 1
else
    if [ -z "$BACKUP_DIR"  ]; then
	s3backup cp $BACKUP_FILE s3://$S3_BUCKET
    else
	s3backup cp $BACKUP_FILE s3://$S3_BUCKET/$BACKUP_DIR/
    fi
fi

rm $BACKUP_FILE
