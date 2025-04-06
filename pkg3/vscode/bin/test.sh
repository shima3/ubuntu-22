#!/bin/bash
# TZ=Asia/Tokyo
# bin=$(dirname $0)
# cd "$bin/.."
# name=$(basename $PWD)
cd "${0%/*}/.."
base="${PWD##*/}"

xrdp_port=3333
list=$(docker ps --format json | jq --raw-output 'select(.Ports | test("^.*:'$xrdp_port'->.*/tcp$")) | .ID')
if [ "$list" != "" ]; then docker stop $list; fi
docker-remove-containers-not-running

# Architecture="$(docker info | awk '$1=="Architecture:"{print $2;}')"

docker run \
       --name "$base" --hostname "$base" \
       -p $xrdp_port:3389 \
       --device /dev/fuse --cap-add SYS_ADMIN \
       --shm-size="1gb" \
       -d --restart unless-stopped \
       -it \
       "test:$base"

# -e TZ=$TZ \

docker exec "$base" useradd -m -s /bin/bash student
echo student:1883shima | docker exec -i "$base" chpasswd

docker exec "$base" bash -c 'while ! ss -tln | grep -q :3389; do echo wait; sleep 1; done'
echo OK
