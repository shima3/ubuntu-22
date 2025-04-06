#!/bin/bash
reg="kshima"
bin="$(dirname $0)"
cd $bin/..
pkgname="$(basename $PWD)"
pkgrepo="pkg_$pkgname"

imgid="$(docker images -q $pkgrepo)"
UbuntuVersion="$(docker inspect --format '{{.Config.Labels.UbuntuVersion}}' $imgid)"
Architecture="$(docker inspect --format '{{.Architecture}}' $imgid)"
if [ "$UbuntuVersion" == "" -o "$Architecture" == "" ]; then echo "Try again"; exit 1; fi

img="$reg/$pkgrepo:ubuntu${UbuntuVersion%%.*}$Architecture"
docker tag "$pkgrepo" "$img"
docker-login.sh
docker push "$img"
