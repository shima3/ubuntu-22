#!/bin/bash
port=8888
# TZ=Asia/Tokyo

bin="$(dirname $0)"
cd "$bin/.."
base=$(basename $PWD)

list=$(docker ps --format json | jq --raw-output 'select(.Ports | test("^.*:'$port'->.*/tcp$")) | .ID')
if [ "$list" != "" ]; then docker stop $list; fi
docker-remove-containers-not-running

# docker run --name "$base" --hostname "$base" -p "$port:80" -e "LC_ALL=ja_JP.UTF-8" -e TZ=$TZ -d --restart always "$base"
docker run --name "$base" --hostname "$base" -p "$port:80" -e "LC_ALL=ja_JP.UTF-8" -d --restart always "test:$base"

# -it
# -e "LANG=$LANG"

# docker exec -i "$base" service apache2 start

