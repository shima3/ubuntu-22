#!/bin/bash
bin="${0%/*}"
cd "$bin/.."
# base="${PWD##*/}"
base="${PWD##*/[0-9]?-}"
osver="$(basename ${PWD%/*/*})"

# docker run -it --rm -v "$PWD:/$PWD" -w "$PWD" "test:$base" /opt/opam/.opam/default/bin/frama-c test.c -slice-return main -then-on 'Slicing export' -print
docker run -it --rm -v "$PWD:/$PWD" -w "$PWD" "test:$base" /opt/opam/.opam/default/bin/frama-c test.c -slice-pragma main -then-on 'Slicing export' -print
