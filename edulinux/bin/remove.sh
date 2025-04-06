#!/bin/bash
# bin=$(dirname $0)
# cd "$bin/.."
# base=$(basename $PWD)
cd "${0%/*}/.."
base="${PWD##*/}"
# osver="$(basename ${PWD%/*})"

# list="$(docker ps --all --filter ancestor=$base --quiet)"
# if [ "$list" != "" ]; then docker stop "${list[@]}"; docker rm "${list[@]}"; fi    

if docker stop "$base" > /dev/null 2> /dev/null; then
    echo -n "rm "
    docker rm "$base"
fi

# docker volume rm "$base-etc" "$base-home" "$base-var"
# docker volume rm "$base-home" "$base-var-log"
docker volume rm "$base-etc" "$base-home" "$base-var-log"
