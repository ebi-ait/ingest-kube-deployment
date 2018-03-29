#!/bin/sh

BACKUP_DIR=/data/db/dump/$(date '+%Y-%m-%dT%H_%M')

mongodump \
--host mongo-service \
--out $BACKUP_DIR

BACKUP_FILE=$BACKUP_DIR.tar.gz
tar -zcvf $BACKUP_DIR $BACKUP_FILE

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
