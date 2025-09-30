#!/bin/bash
script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
base="${PWD##*/}"
container="test"

bin/_run.sh \
    -dit \
    --name "$container" \
    -v $PWD/context/html:/var/www/html \
    "$base"
