#!/usr/bin/env bash

echo "REMINDER: this script is meant to be \`source\`d not executed."

if [ -z $1 ]; then
    echo "Please provide AWS access key file (CSV)."
    exit 1
fi

IFS="," 
read -ra credentials <<< $(awk  -v RS='\r\n' -F "," 'NR==2' $1)

access_key=$(echo ${credentials[0]} | tr -d '\n')
secret_access_key=$(echo ${credentials[1]} | tr -d '\n')


if [[ -z ${access_key} || -z $secret_access_key  ]]; then
    echo "Missing AWS credentials. Please check the file provided."
    exit 1
else
    export AWS_ACCESS_KEY_ID=$access_key
    export AWS_SECRET_ACCESS_KEY=$secret_access_key
fi


