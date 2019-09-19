#!/bin/bash

# enable aliases for non-interactive shell
shopt -s expand_aliases

source aws_setup

s3_path=$S3_BUCKET/$BACKUP_DIR
formatted_date=$(date '+%Y-%m-%d')
backup_file=$(s3backup ls s3://$s3_path/ |\
		  grep ${formatted_date}.* |\
		  awk 'NR==1{print $4}')

if [ ! -z $backup_file ]; then   
    mkdir /data
    cd /data
    s3backup cp s3://$s3_path/$backup_file $backup_file    
    tar -xzvf $backup_file
    backup_directory=${backup_file%.tar.gz}    
    mongorestore --host=$MONGO_HOST data/db/dump/$backup_directory
    /opt/verify.py
else
    echo "Backup file for ${formatted_date} was not found."
    exit 1
fi

