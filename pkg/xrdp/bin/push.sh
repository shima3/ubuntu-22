#!/bin/bash
reg="kshima"
# bin="$(dirname $0)"
# cd "$bin/.."
# base="$(basename $PWD)"
# pkg_base="pkg_$base"
cd "${0%/*}/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*/*})"

function inspect(){
    # 最後の引数
    last_arg="${!#}"
    # 最後の引数を除いたそれ以外の引数を配列として取得
    args_except_last=("${@:1:$(($#-1))}")
    IMAGE_ID=($(docker images "$last_arg" --format "{{.ID}}"))
    docker image inspect ${args_except_last[@]} "$IMAGE_ID"
}

# img="$pkg_base:latest"
# OSVersion="$(docker inspect --format '{{.Config.Labels.OSVersion}}' $img)"
# Architecture="$(docker inspect --format '{{.Architecture}}' pkg:$base)"
Architecture="$(inspect --format '{{.Architecture}}' pkg:$base)"

img="$reg/$osver-pkg:${base}_$Architecture"
docker tag "pkg:$base" "$img"
docker-login.sh
docker push "$img"
