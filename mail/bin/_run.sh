#!/bin/bash
script="$(readlink -f $0)"
# bin=$(dirname $0)
bin="${script%/*}"
cd "$bin/.."
# cd "${0%/*}/.."
# base=$(basename $PWD)
base="${PWD##*/}"
osver="$(basename ${PWD%/*})"

# TZ=Asia/Tokyo

# 前回起動したコンテナがあれば削除する。
list="$(docker ps --all --filter ancestor=$base --quiet)"
if [ "$list" != "" ]; then docker stop $list; docker rm $list; fi

# 停止しているコンテナを削除する。
list=`docker ps -q -f status=exited; docker ps -q -f status=created`
if [ "$list" != "" ]; then docker rm $list; fi

docker run \
       --hostname "$(hostname)" \
       -p "0.0.0.0:25:25" \
       -p "0.0.0.0:110:110" \
       -p "0.0.0.0:143:143" \
       --mount "type=volume,src=$base-etc-ssh,dst=/etc/ssh" \
       "$@"

#       --hostname "$base" \
#       --device /dev/fuse --cap-add SYS_ADMIN \
#       --security-opt apparmor:unconfined \
#       --shm-size="1gb" \
#       --name "$base" --hostname "$(hostname)" \
#       --privileged=true \
#       -e TZ="Japan" \
#       -e "TZ=$TZ" \
#       -p 3333:3389 \
#       -p 2222:22 \
