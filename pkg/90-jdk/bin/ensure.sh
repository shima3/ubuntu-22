#!/bin/bash
script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
base="${PWD##*/[0-9]?-}"
# root="${PWD%/*}"
# osver="${root##*/}"

bin/pull.sh
if ! docker image inspect "pkg:$base" > /dev/null 2>&1; then
    bin/build.sh
fi
