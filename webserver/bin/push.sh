#!/bin/bash
reg="kshima"
script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*})"

id=($(docker images "$base" --format '{{.ID}}'))
arch="$(docker inspect $id --format '{{.Architecture}}')"
img="$reg/$osver-$base:$arch"
docker build --tag "$img" --file Dockerfile.upgrade context

# docker-login.sh
if docker push "$img"; then
    git add ..
    # git commit --message="push $img" --untracked-files=no
    git status --untracked-files=no | grep ': ' | git commit --all --file -
fi

# Ym="$(docker image inspect --format '{{.Created}}' $base | awk -F - '{print $1 $2;}')"
# imgYm="$reg/$osver-$base:$Ym$Architecture"
# docker tag "$base" "$img"
# docker tag "$img" "$imgYm"
# docker push "$imgYm"

id=($(docker images "$img" --format '{{.ID}}'))
ym="$(docker inspect $id --format '{{.Created}}' | cut -c1-7 | tr -d '-')"
imgym="$reg/$osver-$base:$ym$arch"
docker tag "$img" "$imgym"
docker push "$imgym"
