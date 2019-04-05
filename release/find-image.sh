#!/usr/bin/env bash

if [[ -z $1 || -z $2 ]]; then
    echo 'Expecting deployment and version arguments.'
    exit 1
fi

src_dir=$(dirname ${BASH_SOURCE[0]})

deployment=$1
version=$2

function has_match() {
    cat ${src_dir}/version.map | grep -qE '^'${deployment}'\b.*\b'${version}'.*$'
}


if has_match; then
    cat ${src_dir}/version.map | grep -E '^'${deployment}'\b.*\b'${version}'.*$' | awk '{printf("%s -> %s\n", $3, $2)}'
else
    echo "No results found for [${deployment}]."
fi
