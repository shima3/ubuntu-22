#!/bin/bash
reg="kshima"
bin="$(dirname $0)"
cd $bin/..
# name="$(basename $PWD)"
pkgname="$(basename $PWD)"
# pkg="${name}_pkg"
pkgrepo="pkg_$pkgname"

imgid="$(docker images -q $pkgrepo)"
# GccVersion="$(docker inspect --format '{{.Config.Labels.GccVersion}}' gcc.pkg)"
UbuntuVersion="$(docker inspect --format '{{.Config.Labels.UbuntuVersion}}' $imgid)"
Architecture="$(docker inspect --format '{{.Architecture}}' $imgid)"
if [ "$UbuntuVersion" == "" -o "$Architecture" == "" ]; then echo "Try again"; exit 1; fi

img="$reg/$pkgrepo:ubuntu${UbuntuVersion%%.*}$Architecture"
docker tag "$pkgrepo" "$img"

# OS_VERSION="ubuntu${UbuntuVersion%%.*}"
# prefix="kshima/${OS_VERSION}_pkg:${name}_"
# repo="$prefix$Architecture"
# docker tag "$pkg" "$repo"

docker-login.sh
docker push "$img"

# manifest="kshima/pkg_$name:$OS_VERSION"
# if ! docker manifest create --amend "$manifest" "${prefix}amd64" "${prefix}arm64"; then exit 1; fi
# docker manifest push "$manifest"
