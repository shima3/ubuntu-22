#!/bin/bash
bin="${0%/*}"
cd "$bin/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*/*})"

docker run -it --rm -v "$PWD:/$PWD" -w "$PWD" "test:$base" bash
