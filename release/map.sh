#!/usr/bin/env bash

src_dir=$(dirname ${BASH_SOURCE[0]})
map_file=${src_dir}/version.map

mapping="$*"
echo -e "\n${mapping}" >> ${map_file}
