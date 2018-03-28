#!/bin/sh

inotifywait -mrq -e modify --format '%w%f' /data/sync/ | while read FILE
do 
    aws s3 cp $FILE s3://$S3_BUCKET
done
