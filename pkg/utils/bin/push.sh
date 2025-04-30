#!/bin/bash
reg="kshima"
script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*/*})"
pkg="pkg:$base"

# Architecture="$(docker inspect --format '{{.Architecture}}' --type=image $pkg)"
id=($(docker images "$pkg" --format '{{.ID}}'))
arch="$(docker inspect $id --format '{{.Architecture}}')"
ym="$(docker inspect $id --format '{{.Created}}' | cut -c1-7 | tr -d '-')"

# img="$reg/$osver-${pkg}_$Architecture"
img="$reg/$osver-${pkg}_$arch"
imgym="$reg/$osver-${pkg}_$ym$arch"

docker tag "$pkg" "$img"
docker tag "$pkg" "$imgym"

docker-login.sh
docker push "$img"
docker push "$imgym"
