#!/bin/bash
PACKAGE="git"

# bin="$(dirname $0)"
# cd $bin/..
cd "${0%/*}/.."
# pkgname="$(basename $PWD)"
base="${PWD##*/}"
# pkgrepo="pkg_$pkgname"
osver="$(basename ${PWD%/*/*})"

tag="ubuntu${UbuntuVersion%%.*}$Architecture"
function pkg_pull(){
    remote="kshima/pkg_$1:$tag"
    echo "remote=$remote"
    docker pull $remote
    docker tag $remote pkg_$1
}

if ! docker build --tag "test:$base" --target test-stage --build-arg "PACKAGE=$PACKAGE" -f Dockerfile context; then exit 1; fi
if ! docker build --tag "pkg:$base" --target package-stage --build-arg "PACKAGE=$PACKAGE" --label "OS-Ver=$osver" -f Dockerfile context; then exit 1; fi

docker-remove-nameless-images
