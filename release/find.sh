#!/usr/bin/env bash

if [[ -z $1 || -z $2 || -z $3 ]]; then
    echo 'Invalid arguments. Expecting command, deployment, and search key.'
    exit 1
fi

src_dir=$(dirname ${BASH_SOURCE[0]})

command=$1
deployment=$2
search_key=$3

function has_match() {
    cat ${src_dir}/version.map | grep -qE '^'${deployment}'\b.*\b'${search_key}'.*$'
}

function version() {
    if has_match; then
       cat ${src_dir}/version.map | grep -E '^'${deployment}'\b.*\b'${search_key}'.*$' | awk '{printf("%s -> %s\n", $3, $2)}'
    else
	echo "No results found for '${search_key}' in [${deployment}]."
    fi
}

$command
