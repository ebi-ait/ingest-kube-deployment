#!/bin/bash

# enable aliases for non-interactive shell
shopt -s expand_aliases

source aws_setup

s3_path=$S3_BUCKET/$BACKUP_DIR
formatted_date=$(date '+%Y-%m-%d')
backup_file=$(s3backup ls s3://$s3_path/ |\
		  grep ${formatted_date}.* |\
		  awk 'NR==1{print $4}')

exit_status=0

if [ ! -z $backup_file ]; then   
    mkdir /data
    cd /data
    s3backup cp s3://$s3_path/$backup_file $backup_file    
    tar -xzvf $backup_file
    backup_directory=${backup_file%.tar.gz}

    echo "Restoring backup file [${backup_file}]..."
    mongorestore --host=$MONGO_HOST -u $MONGO_USER -p $MONGO_PASSWORD data/db/dump/$backup_directory
    echo "Restored backup file [${backup_file}]."

    /opt/verify.py
else
    echo "Backup file for ${formatted_date} was not found."
    exit_status=1
fi

mongo --host=$MONGO_HOST admin -u $MONGO_USER -p $MONGO_PASSWORD --eval 'db.shutdownServer()'
exit $exit_status
