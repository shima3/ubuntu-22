#!/bin/bash
script="$(readlink -f $0)"
# bin=$(dirname $0)
bin="${script%/*}"
cd "$bin/.."
base=$(basename $PWD)
if [[ "$*" == "" ]]
then cmd="bash -l"
else cmd="$*"
fi
list="$(docker ps --all --filter ancestor=$base --quiet)"
# docker exec -it $base $cmd
docker exec -it $list $cmd
