#!/bin/bash

# enable aliases for non-interactive shell
shopt -s expand_aliases

source aws_setup

formatted_date=$(date '+%Y-%m-%d')
backup_file=$(s3backup ls s3://ingest-backup/dev/ --recursive |\
		 grep ${formatted_date}.* | awk 'NR==1{print $4}')

if [ ! -z $backup_file ]; then
    echo $backup_file
else
    echo "Backup file for ${formatted_date} was not found."
    exit 1
fi

