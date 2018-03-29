#!/bin/sh

BACKUP_FILE=/data/db/dump/$(date '+%Y-%m-%dT%H_%M').gz

mongodump \ 
  --host mongo-service \
  --gzip \ 
  --out $BACKUP_FILE

if [ -z "$S3_BUCKET" ]; then
    echo "S3 Bucket not specified!"
else
    if [ -z "$BACKUP_DIR"  ]; then
	aws s3 cp $BACKUP_FILE /data/sync/* s3://$S3_BUCKET
    else
	aws s3 cp $BACKUP_FILE s3://$S3_BUCKET/$BACKUP_DIR/
    fi
fi

rm $BACKUP_FILE
