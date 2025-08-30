#!/bin/bash
port=7681

bin="$(dirname $0)"
cd "$bin/.."
# base=$(basename $PWD)
base="${PWD##*/[0-9]?-}"

list=$(docker ps --format json | jq --raw-output 'select(.Ports | test("^.*:'$port'->.*/tcp$")) | .ID')
if [ "$list" != "" ]; then docker stop $list; fi
docker-remove-containers-not-running

docker run --name "$base" --hostname "$base" -p "$port:7681" -e "LC_ALL=ja_JP.UTF-8" -d --restart always "test:$base"
