#!/bin/bash
bin="$(dirname $0)"
cd "$bin/.."
base="$(basename $PWD)"

docker run -it --rm -v "$PWD:/$PWD" -w "$PWD" "$base"
