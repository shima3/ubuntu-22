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
ttyd_port=7777
nodejs_ports='3000-3009'

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
       --hostname "$base" \
       -p "0.0.0.0:$xrdp_port:3389" \
       -p "0.0.0.0:$http_port:80" \
       -p "0.0.0.0:$ssh_port:22" \
       -p "0.0.0.0:$ttyd_port:7681" \
       -p "0.0.0.0:$nodejs_ports:$nodejs_ports" \
       -p "0.0.0.0:443:443" \
       --device /dev/fuse --cap-add SYS_ADMIN \
       --security-opt apparmor:unconfined \
       --shm-size="1gb" \
       --mount "type=volume,src=$base-etc-ssh,dst=/etc/ssh" \
       --mount "type=volume,src=$base-etc-letsencrypt,dst=/etc/letsencrypt" \
       --mount "type=volume,src=$base-var-lib-letsencrypt,dst=/var/lib/letsencrypt" \
       "$@"

#       --name "$base" --hostname "$(hostname)" \
#       --privileged=true \
#       -e TZ="Japan" \
#       -e "TZ=$TZ" \
#       -p 3333:3389 \
#       -p 2222:22 \
