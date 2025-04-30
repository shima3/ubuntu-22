#!/bin/bash
reg="kshima"
script="$(readlink -f $0)"
bin="${script%/*}"
# cd "${0%/*}/.."
cd "$bin/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*})"

# Architecture="$(docker inspect --format '{{.Architecture}}' --type=image $base)"
id=($(docker images "$base" --format '{{.ID}}'))
arch="$(docker inspect $id --format '{{.Architecture}}')"
img="$reg/$osver-$base:$arch"

# img="$reg/$osver-$base:$Architecture"
docker tag "$base" "$img"

docker-login.sh
docker push "$img"

ym="$(docker inspect $id --format '{{.Created}}' | cut -c1-7 | tr -d '-')"
imgym="$reg/$osver-$base:$ym$arch"
docker tag "$img" "$imgym"
docker push "$imgym"
