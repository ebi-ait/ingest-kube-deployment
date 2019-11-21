#!/bin/bash

# enable aliases for non-interactive shell
shopt -s expand_aliases

source aws_setup

DB_DUMP=/data/db/dump/$(date '+%Y-%m-%dT%H_%M')

mongodump \
--host mongo-service \
--out $DB_DUMP

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
