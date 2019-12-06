#!/bin/bash
if [ -z "$1" ]; then
    echo "Please pass in scale number as a parameter"
    exit 1
fi

re='^[0-9]+$'
if ! [[ $1 =~ $re ]] ; then
   echo "error: scale parameter should be a number" >&2; exit 1
fi

ABS_SCRIPT_LOC=$(cd -P -- "$(dirname -- "$0")" && pwd -P)

sudo docker-compose --file $ABS_SCRIPT_LOC/docker-compose.yaml up --scale chrome=$1 -d
