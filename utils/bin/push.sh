#!/bin/bash
reg="kshima"
# bin="$(dirname $0)"
# cd "$bin/.."
# base="$(basename $PWD)"
cd "${0%/*}/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*})"

# OSVersion="$(docker inspect --format '{{.Config.Labels.OSVersion}}' --type=image $pkg_base)"
Architecture="$(docker inspect --format '{{.Architecture}}' --type=image $base)"
# Architecture="$(docker info | awk '$1=="Architecture:"{print $2;}')"

img="$reg/$osver-$base:$Architecture"
docker tag "$base" "$img"
docker-login.sh
docker push "$img"
