#!/bin/bash
script="$(readlink -f $0)"
# bin=$(dirname $0)
bin="${script%/*}"
cd "$bin/.."
base="${PWD##*/[0-9]?-}"
if [[ "$*" == "" ]]
then cmd="bash"
else cmd="$*"
fi
docker exec -it $base $cmd

