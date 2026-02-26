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
# Architecture="$(inspect --format '{{.Architecture}}' $pkg)"

id=($(docker images "$pkg" --format '{{.ID}}'))
arch="$(docker inspect $id --format '{{.Architecture}}')"
ym="$(docker inspect $id --format '{{.Created}}' | cut -c1-7 | tr -d '-')"

# img="$reg/$osver-${pkg}_$Architecture"
img="$reg/$osver-${pkg}_$arch"
imgym="$reg/$osver-${pkg}_$ym$arch"

docker tag "$pkg" "$img"
docker tag "$pkg" "$imgym"

# docker-login.sh
docker push "$img"
docker push "$imgym"
