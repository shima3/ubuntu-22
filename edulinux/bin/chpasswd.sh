#!/bin/bash
script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
base=$(basename $PWD)
docker exec -it $base passwd $*
