#!/bin/bash
bin="$(dirname $0)"
cd "$bin/.."
base=$(basename $PWD)

docker exec -it "$base" bash
