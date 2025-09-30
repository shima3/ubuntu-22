#!/bin/bash
cd "${0%/*}/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*})"

# 前回起動したコンテナがあれば削除する。
list="$(docker ps --all --filter ancestor=$base --quiet)"
if [ "$list" != "" ]; then docker stop $list; docker rm $list; fi

# 停止しているコンテナを削除する。
list=`docker ps -q -f status=exited; docker ps -q -f status=created`
if [ "$list" != "" ]; then docker rm $list; fi

docker run \
       --hostname "$base" \
       -p "0.0.0.0:80:80" \
       -p "0.0.0.0:443:443" \
       --device /dev/fuse --cap-add SYS_ADMIN \
       --security-opt apparmor:unconfined \
       --shm-size="1gb" \
       --network mynet \
       "$@"

#       -e TZ="Japan" \
#       -e "TZ=$TZ" \
