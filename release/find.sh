#!/usr/bin/env bash

ARGS=()
display_mode="default"

for arg in "$@"; do
    case $arg in
	-v|--version)
	    if [[ "${display_mode}" != "default" ]]; then
		echo "Multiple display modes selected."
		exit 1
	    fi
	    display_mode=version
	    shift
	    ;;
	-i|--image)
	    if [[ "${display_mode}" != "default" ]]; then
		echo "Multiple display modes selected."
		exit 1
	    fi
	    display_mode=image
	    shift
	    ;;
	*)
	    ARGS+=("$1")
	    shift
	    ;;
    esac
done

set -- "${ARGS[@]}"
if [[ -z $1 || -z $2 ]]; then
    echo 'Invalid arguments. Expecting deployment, and search key.'
    exit 1
fi

src_dir=$(dirname ${BASH_SOURCE[0]})

deployment=$1
search_key=$2

function has_match() {
    cat ${src_dir}/version.map | grep -qE '^'${deployment}'\b.*\b'${search_key}'.*$'
}

if has_match; then
    case $display_mode in
	version)
	    awk_command='{printf("%s\n", $3)}'
	    ;;
	image)
	    awk_command='{printf("%s\n", $2)}'
	    ;;
	*)
	    awk_command='{printf("%s -> %s\n", $3, $2)}'
	    ;;
    esac
    cat ${src_dir}/version.map | grep -E '^'${deployment}'\b.*\b'${search_key}'.*$' | awk "${awk_command}"
else
    echo "No results found for '${search_key}' in [${deployment}]."
fi

