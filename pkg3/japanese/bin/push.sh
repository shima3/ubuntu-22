#!/bin/bash
reg="kshima"
# bin="$(dirname $0)"
# cd "$bin/.."
# base="$(basename $PWD)"
# pkg_base="pkg_$base"
cd "${0%/*}/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*/*})"

Architecture="$(docker inspect --format '{{.Architecture}}' --type=image pkg:$base)"

img="$reg/$osver-pkg:${base}_$Architecture"
docker tag "pkg:$base" "$img"
docker-login.sh
docker push "$img"
