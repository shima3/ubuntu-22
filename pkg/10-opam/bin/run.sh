#!/bin/bash
bin="${0%/*}"
cd "$bin/.."
# base="${PWD##*/}"
base="${PWD##*/[0-9]?-}"
osver="$(basename ${PWD%/*/*})"

docker run -it --rm -v "$PWD:/$PWD" -w "$PWD" "test:$base" bash -l
