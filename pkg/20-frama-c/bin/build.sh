#!/bin/bash
script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
base="${PWD##*/[0-9]?-}"
root="${PWD%/*/*}"
osver="${root##*/}"

$root/base/bin/pull.sh
../10-opam/bin/pull.sh

list="$(docker ps --filter ancestor=$base -q)"
if [ "$list" != "" ]; then docker rm -f "$list"; fi

if ! docker build --tag "test:$base" --build-arg "PACKAGE=$PACKAGE" .; then exit 1; fi
if ! docker build --tag "pkg:$base" --target package-stage --build-arg "PACKAGE=$PACKAGE" --label "OSVersion=${osver/-/:}.04" .; then exit 1; fi
