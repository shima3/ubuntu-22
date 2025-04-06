#!/bin/bash
reg="kshima"
# bin="$(dirname $0)"
# cd "$bin/.."
# base="$(basename $PWD)"
# pkg_base="pkg_$base"
cd "${0%/*}/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*/*})"

# img="$pkg_base:latest"
# OSVersion="$(docker inspect --format '{{.Config.Labels.OSVersion}}' $img)"
Architecture="$(docker inspect --format '{{.Architecture}}' pkg:$base)"

img="$reg/$osver-pkg:${base}_$Architecture"
docker tag "pkg:$base" "$img"
docker-login.sh
docker push "$img"
