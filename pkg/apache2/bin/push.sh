#!/bin/bash
reg="kshima"
script="$(readlink -f $0)"
# bin="$(dirname $0)"
bin="${script%/*}"
cd "$bin/.."
# base="$(basename $PWD)"
# base="${PWD##*/[0-9]?-}"
base="${PWD##*/}"
osver="$(basename ${PWD%/*/*})"
# pkg_base="pkg_$base"
pkg="pkg:$base"

# OSVersion="$(docker inspect --format '{{.Config.Labels.OSVersion}}' --type=image $pkg_base)"
# Architecture="$(docker inspect --format '{{.Architecture}}' --type=image $pkg_base)"
# if [ "$OSVersion" == "" -o "$Architecture" == "" ]; then echo "Try again"; exit 1; fi
id=($(docker images "$pkg" --format '{{.ID}}'))
arch="$(docker inspect $id --format '{{.Architecture}}')"
ym="$(docker inspect $id --format '{{.Created}}' | cut -c1-7 | tr -d '-')"

# img="$reg/$pkg_base:${OSVersion%%.*}$Architecture"
img="$reg/$osver-${pkg}_$arch"
imgym="$reg/$osver-${pkg}_$ym$arch"

# docker tag "$pkg_base" "$img"
docker tag "$pkg" "$img"
docker tag "$pkg" "$imgym"

docker-login.sh
docker push "$img"
docker push "$imgym"
