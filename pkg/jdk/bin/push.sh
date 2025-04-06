#!/bin/bash
reg="kshima"
# bin="$(dirname $0)"
# cd "$bin/.."
# base="$(basename $PWD)"
# pkg_base="pkg_$base"
cd "${0%/*}/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*/*})"

# OSVersion="$(docker inspect --format '{{.Config.Labels.OSVersion}}' --type=image $pkg_base)"
# Architecture="$(docker inspect --format '{{.Architecture}}' $pkg_base)"
# if [ "$OSVersion" == "" -o "$Architecture" == "" ]; then echo "Try again"; exit 1; fi

img="$reg/$osver-pkg:${base}_$Architecture"
docker tag "pkg:$base" "$img"
docker-login.sh
docker push "$img"
