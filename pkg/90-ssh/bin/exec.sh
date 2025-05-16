#!/bin/bash
bin="$(dirname $0)"
cd "$bin/.."
# base="$(basename $PWD)"
base="${PWD##*/[0-9]?-}"

docker exec -it "$base" bash
