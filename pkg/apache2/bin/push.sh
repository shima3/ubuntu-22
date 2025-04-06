#!/bin/bash
reg="kshima"
bin="$(dirname $0)"
cd "$bin/.."
base="$(basename $PWD)"
pkg_base="pkg_$base"

OSVersion="$(docker inspect --format '{{.Config.Labels.OSVersion}}' --type=image $pkg_base)"
Architecture="$(docker inspect --format '{{.Architecture}}' --type=image $pkg_base)"
if [ "$OSVersion" == "" -o "$Architecture" == "" ]; then echo "Try again"; exit 1; fi

# img="$reg/$pkgrepo:${OSVersion%%.*}$Architecture"
# docker tag "$pkgrepo" "$img"
img="$reg/$pkg_base:${OSVersion%%.*}$Architecture"
docker tag "$pkg_base" "$img"

docker-login.sh
docker push "$img"
