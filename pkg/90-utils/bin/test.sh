#!/bin/bash
# bin="$(dirname $0)"
bin="${0%/*}"
cd "$bin/.."
# base="$(basename $PWD)"
base="${PWD##*/[0-9]*-}"

docker run --rm -it "$base" bash
