#!/bin/bash
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

$root/base/bin/pull.sh
for dir in $root/pkg/*; do $dir/bin/pull.sh; done

list="$(docker ps --filter ancestor=$base -q)"
if [ "$list" != "" ]; then docker stop $list; fi

docker build --tag "$base" --label "OS-Ver=$osver" --file Dockerfile context

list=`docker ps -q -f status=exited; docker ps -q -f status=created`
if [ "$list" != "" ]; then docker rm $list; fi
list="$(docker images -f dangling=true -q)"
if [ "$list" != "" ]; then docker rmi $list; fi

echo -e "\a\a\a"
