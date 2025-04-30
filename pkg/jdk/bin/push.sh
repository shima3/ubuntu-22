#!/bin/bash
reg="kshima"
script="$(readlink -f $0)"
bin="${script%/*}"
# cd "${0%/*}/.."
cd "$bin/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*/*})"
pkg="pkg:$base"

id=($(docker images "$pkg" --format '{{.ID}}'))
arch="$(docker inspect $id --format '{{.Architecture}}')"
ym="$(docker inspect $id --format '{{.Created}}' | cut -c1-7 | tr -d '-')"

# img="$reg/$osver-pkg:${base}_$Architecture"
img="$reg/$osver-${pkg}_$arch"
imgym="$reg/$osver-${pkg}_$ym$arch"

# docker tag "pkg:$base" "$img"
docker tag "$pkg" "$img"
docker tag "$pkg" "$imgym"

docker-login.sh
docker push "$img"
docker push "$imgym"
