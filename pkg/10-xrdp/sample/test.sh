#!/bin/bash
bin=$(dirname $0)
cd $bin/..
base="$(basename $PWD)"

# list=$(docker ps --format json | jq --raw-output 'select(.Ports | test("^.*:3333->.*/tcp$")) | .ID')
# if [ "$list" != "" ]; then docker stop $list; fi

# docker rm "$base"
docker run -it -v $PWD/sample/xrdp-sesman.log:/var/log/xrdp-sesman.log -v $PWD/context/xrdp-last.sh:/usr/local/sbin/xrdp-last.sh "test:$base" bash

# Window Managerがないので、ログインはできない。
# docker exec "$base" useradd -m -s /bin/bash student
# echo student:1883shima | docker exec -i "$base" chpasswd
