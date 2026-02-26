#!/bin/bash
# port=3000

bin="$(dirname $0)"
cd "$bin/.."
base="${PWD##*/[0-9]?-}"

list=$(docker ps --format json | jq --raw-output 'select(.Ports | test("^.*:'$port'->.*/tcp$")) | .ID')
if [ "$list" != "" ]; then docker stop $list; fi
docker-remove-containers-not-running

docker run --name "$base" --hostname "$base" -e "LC_ALL=ja_JP.UTF-8" -it --rm --tmpfs /tmp:exec "test:$base" bash
