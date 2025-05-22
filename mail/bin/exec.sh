#!/bin/bash
script="$(readlink -f $0)"
# bin=$(dirname $0)
bin="${script%/*}"
cd "$bin/.."
base=$(basename $PWD)

# 前回起動したコンテナがあれば削除する。
list="$(docker ps --all --filter ancestor=$base --quiet)"

if [[ "$*" == "" ]]
then cmd="bash"
else cmd="$*"
fi

docker exec -it $list $cmd
