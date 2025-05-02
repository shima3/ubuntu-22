#!/bin/bash
# TZ=Asia/Tokyo
TZ="Japan"
bin="$(dirname $0)"
cd "$bin/.."
base="$(basename $PWD)"

ssh_port=2222
list="$(docker ps --format json | jq --raw-output 'select(.Ports | test("^.*:'$ssh_port'->.*/tcp$")) | .ID')"
if [ "$list" != "" ]; then
    echo "stop $list"
    docker stop $list
fi
docker-remove-containers-not-running

docker run -it \
       --name "$base" --hostname "$base" \
       -p "$ssh_port:22" \
       "$base" bash
