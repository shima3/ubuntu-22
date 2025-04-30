#!/bin/bash
bin="$(dirname $0)"
cd "$bin/.."
base="$(basename $PWD)"

docker run --rm -it "$base" bash
