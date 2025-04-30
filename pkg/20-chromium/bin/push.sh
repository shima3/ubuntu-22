#!/bin/bash
reg="kshima"
script="$(readlink -f $0)"
# cd "${0%/*}/.."
bin="${script%/*}"
cd "$bin/.."
# base="${PWD##*/}"
base="${PWD##*/[0-9]?-}"
osver="$(basename ${PWD%/*/*})"
pkg="pkg:$base"

function inspect(){
    # 最後の引数
    last_arg="${!#}"
    # 最後の引数を除いたそれ以外の引数を配列として取得
    args_except_last=("${@:1:$(($#-1))}")
    IMAGE_ID=($(docker images "$last_arg" --format "{{.ID}}"))
    docker image inspect ${args_except_last[@]} "$IMAGE_ID"
}

# Architecture="$(docker inspect --format '{{.Architecture}}' --type=image pkg:$base)"
Architecture="$(inspect --format '{{.Architecture}}' $pkg)"

# img="$reg/$osver-pkg:${base}_$Architecture"
img="$reg/$osver-${pkg}_$Architecture"
# docker tag "pkg:$base" "$img"
docker tag "$pkg" "$img"
docker-login.sh
docker push "$img"
