#!/bin/bash
# bin="$(dirname $0)"
bin="${0%/*}"
cd "$bin/.."
# base="$(basename $PWD)"
base="${PWD##*/}"

# docker run -it --rm -v "$PWD:/$PWD" -w "$PWD" -v "$PWD/context/bin:/usr/local/bin" "$base"
docker run -it --rm -v "$PWD:/$PWD" -w "$PWD" "test:$base" bash
