#!/bin/bash
bin="${0%/*}"
cd "$bin/.."
base="${PWD##*/}"

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
       -d \
       "test:$base"

docker exec "$base" useradd -m -s /bin/bash student
echo student:1883shima | docker exec -i "$base" chpasswd
