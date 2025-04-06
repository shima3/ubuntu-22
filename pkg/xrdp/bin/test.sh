#!/bin/bash
bin=$(dirname $0)
cd $bin/..
base="$(basename $PWD)"

list=$(docker ps --format json | jq --raw-output 'select(.Ports | test("^.*:3333->.*/tcp$")) | .ID')
if [ "$list" != "" ]; then docker stop $list; fi
# docker-remove-containers-not-running

docker rm "$base"
docker run -dit \
       --name "$base" --hostname "$base" \
       -p 3333:3389 \
       --device /dev/fuse --cap-add SYS_ADMIN \
       "test:$base"

# Window Managerがないので、ログインはできない。
docker exec "$base" useradd -m -s /bin/bash student
echo student:1883shima | docker exec -i "$base" chpasswd
