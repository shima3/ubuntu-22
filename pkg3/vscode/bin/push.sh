#!/bin/bash
reg="kshima"
bin="$(dirname $0)"
cd "$bin/.."
base="$(basename $PWD)"
pkg_base="pkg_$base"

img="$pkg_base:latest"
OSVersion="$(docker inspect --format '{{.Config.Labels.OSVersion}}' $img)"
Architecture="$(docker inspect --format '{{.Architecture}}' $img)"
if [ "$OSVersion" == "" -o "$Architecture" == "" ]; then echo "Try again"; exit 1; fi

img="$reg/$pkg_base:${OSVersion%%.*}$Architecture"
docker tag "$pkg_base" "$img"

docker-login.sh
docker push "$img"
