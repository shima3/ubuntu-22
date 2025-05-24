#!/bin/bash
if ! which skopeo > /dev/null; then
    echo 'skopeo: コマンドが見つかりません'
    exit 1
fi

# 実行中ではないコンテナを削除する。
list=`docker ps -q -f status=exited; docker ps -q -f status=created`
if [ "$list" != "" ]; then docker rm $list; fi
# 名前のないイメージを削除する。
list="$(docker images -f dangling=true -q)"
if [ "$list" != "" ]; then docker rmi $list; fi

script="$(readlink -f $0)"
bin="${script%/*}"
# cd "${0%/*}/.."
cd "$bin/.."
base="${PWD##*/}"
root="${PWD%/*}"
# osver="$(basename ${PWD%/*})"
osver="${root##*/}"

# img="${osver/-/:}.04"
# docker pull "$img"
# docker tag "$img" ubuntu

# $root/base/bin/pull.sh
$root/base/bin/ensure.sh
# for name in $(awk '/^COPY --from=pkg:/{ print substr($2, 12); }' Dockerfile); do $root/pkg/[0-9]?-$name/bin/pull.sh; done
for name in $(awk '/^COPY --from=pkg:/{ print substr($2, 12); }' Dockerfile); do $root/pkg/[0-9]?-$name/bin/ensure.sh; done

list="$(docker ps --filter ancestor=$base -q)"
# if [ "$list" != "" ]; then docker stop $list; fi

docker build --tag "$base" --label "OS-Ver=$osver" --file Dockerfile context

echo -e "\a\a\a"
