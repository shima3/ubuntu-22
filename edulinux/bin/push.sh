#!/bin/bash
reg="kshima"
# bin="$(dirname $0)"
# cd "$bin/.."
# base="$(basename $PWD)"
cd "${0%/*}/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*})"

Architecture="$(docker inspect --format '{{.Architecture}}' --type=image $base)"

img="$reg/$osver-$base:$Architecture"
# docker tag "$base" "$img"
docker build --tag "$img" --file Dockerfile.upgrade context

# docker-login.sh
if docker push "$img"; then
    git add ..
    git commit --message="push $img" --untracked-files=no
fi

Ym="$(docker image inspect --format '{{.Created}}' $base | awk -F - '{print $1 $2;}')"
imgYm="$reg/$osver-$base:$Ym$Architecture"
# docker tag "$base" "$img"
docker tag "$img" "$imgYm"
docker push "$imgYm"
