#!/bin/bash
# TZ=Asia/Tokyo
# bin="$(dirname $0)"
# cd "$bin/.."
cd "${0%/*}/.."
# base="$(basename $PWD)"
base="${PWD##*/}"

# docker stop xrdp
list=$(docker ps --format json | jq --raw-output 'select(.Ports | test("^.*:3333->.*/tcp$")) | .ID')
if [ "$list" != "" ]; then docker stop $list; fi
docker-remove-containers-not-running

docker run -dit \
       --name "$base" --hostname "$base" \
       -p 3333:3389 \
       --device /dev/fuse --cap-add SYS_ADMIN \
       "test:$base"

docker exec "$base" useradd -m -s /bin/bash student
echo student:1883shima | docker exec -i "$base" chpasswd

#       --shm-size="1gb" \
#       -e TZ=$TZ \
# -e LANG=$LANG \
# --mount type=volume,src=etc,dst=/etc --mount type=volume,src=home,dst=/home

docker exec "$base" bash -c 'while ! ss -tln | grep -q :3389; do echo wait; sleep 1; done'
echo OK
