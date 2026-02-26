#!/bin/bash
script="$(readlink -f $0)"
# bin="$(dirname $0)"
bin="${script%/*}"
cd "$bin/.."
# base="$(basename $PWD)"
base="${PWD##*/[0-9]?-}"

docker run -it --rm -v "$PWD:/$PWD" -w "$PWD" "test:$base" bash
