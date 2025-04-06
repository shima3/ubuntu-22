#!/bin/bash
# bin=$(dirname $0)
# cd "$bin/.."
# base=$(basename $PWD)
cd "${0%/*}/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*})"

# TZ=Asia/Tokyo
xrdp_port=3333
http_port=8888
ssh_port=2222

# 前回起動したコンテナがあれば削除する。
# list="$(docker ps --all --filter ancestor=$base --quiet)"
# if [ "$list" != "" ]; then docker stop $list; docker rm $list; fi

# $port番ポートを使っているコンテナを停止する。
list=$(docker ps --format json | jq --raw-output 'select(.Ports | test("^.*:'$xrdp_port'->.*/tcp$")) | .ID')
if [ "$list" != "" ]; then docker stop $list; fi
list=$(docker ps --format json | jq --raw-output 'select(.Ports | test("^.*:'$http_port'->.*/tcp$")) | .ID')
if [ "$list" != "" ]; then docker stop $list; fi
list=$(docker ps --format json | jq --raw-output 'select(.Ports | test("^.*:'$ssh_port'->.*/tcp$")) | .ID')
if [ "$list" != "" ]; then docker stop $list; fi

# 停止しているコンテナを削除する。
list=`docker ps -q -f status=exited; docker ps -q -f status=created`
if [ "$list" != "" ]; then docker rm $list; fi

docker run \
       --name "$base" \
       --hostname "$base" \
       -p "$xrdp_port:3389" -p "$http_port:80" -p "$ssh_port:22" \
       --device /dev/fuse --cap-add SYS_ADMIN \
       --security-opt apparmor:unconfined \
       --shm-size="1gb" \
       --mount "type=volume,src=$base-etc-ssh,dst=/etc/ssh" \
       --ulimit core=0 \
       "$@"

#       --name "$base" --hostname "$(hostname)" \
#       --privileged=true \
#       -e TZ="Japan" \
#       -e "TZ=$TZ" \
#       -p 3333:3389 \
#       -p 2222:22 \

docker exec -i "$base" config-apache2.sh "$(hostname)"
