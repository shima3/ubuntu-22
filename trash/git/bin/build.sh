#!/bin/bash
PACKAGE="git"

# bin="$(dirname $0)"
# cd $bin/..
# pkgname="$(basename $PWD)"
# pkgrepo="pkg_$pkgname"
cd "${0%/*}/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*/*})"

# imgid="$(docker images -q ubuntu:latest)"
# UbuntuVersion="$(docker inspect --format '{{json .Config.Labels}}' $imgid | jq --raw-output '.["org.opencontainers.image.version"]')"
# Architecture="$(docker inspect --format '{{.Architecture}}' $imgid)"
# if [ "$UbuntuVersion" == "" -o "$Architecture" == "" ]; then echo "Try again"; exit 1; fi

# tag="ubuntu${UbuntuVersion%%.*}$Architecture"
function pkg_pull(){
    remote="kshima/pkg_$1:$tag"
    echo "remote=$remote"
    docker pull $remote
    docker tag $remote pkg_$1
}
# pkg_pull "xz-utils"

if ! docker build --tag "test:$base" --build-arg "PACKAGE=$PACKAGE" --target test-stage .; then exit 1; fi
if ! docker build --tag "pkg:$base" --target package-stage --label "OS-Ver=$osver" --build-arg "PACKAGE=$PACKAGE" .; then exit 1; fi

# docker-remove-nameless-images
