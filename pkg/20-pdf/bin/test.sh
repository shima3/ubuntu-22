#!/bin/bash
# bin="$(dirname $0)"
bin="${0%/*}"
cd "$bin/.."
# base="$(basename $PWD)"
base="${PWD##*/}"

# docker run -it --rm -v "$PWD:/$PWD" -w "$PWD" "$base"
docker run -it --rm -v "$PWD/context/pkgcheck.sh:/usr/local/bin/pkgcheck.sh" "$base" bash pkgcheck.sh
