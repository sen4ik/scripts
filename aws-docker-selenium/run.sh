#!/bin/bash
if [ -z "$1" ]; then
    echo "Please pass in scale number as a parameter"
    exit 1
fi

re='^[0-9]+$'
if ! [[ $1 =~ $re ]] ; then
   echo "error: scale parameter should be a number" >&2; exit 1
fi

sudo docker-compose --file docker-compose.yaml up --scale chrome=$1 -d
