#!/bin/bash
cd "${0%/*}/.."
base="${PWD##*/}"

xrdp_port=3333
list="$(docker ps --format json | jq --raw-output 'select(.Ports | test("^.*:'$xrdp_port'->.*/tcp$")) | .ID')"
if [ "$list" != "" ]; then
    echo stop $list
    docker stop $list
fi
docker-remove-containers-not-running

docker run -dit \
       --name "$base" --hostname "$base" \
       -p "$xrdp_port:3389" \
       --device /dev/fuse --cap-add SYS_ADMIN \
       "test:$base"

docker exec "$base" useradd -m -s /bin/bash student
echo student:1883shima | docker exec -i "$base" chpasswd
