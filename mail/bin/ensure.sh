#!/bin/bash
script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
base="${PWD##*/}"
# root="${PWD%/*}"
# osver="${root##*/}"

bin/pull.sh
if ! docker image inspect "$base" > /dev/null 2>&1; then
    bin/build.sh
fi
