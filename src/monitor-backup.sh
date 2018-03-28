#!/bin/sh

inotifywait -qr -e modify --format '%w%f' /data/sync/ | while read FILE
do 
    if [ -z "$S3_BUCKET" ]; then
	if [ -z "$BACKUP_DIR"  ]; then
	    aws s3 cp $FILE s3://$S3_BUCKET/$BACKUP_DIR/
	else
	    aws s3 cp $FILE s3://$S3_BUCKET
	fi
    else
	echo "S3 Bucket not specified!"
    fi
done
