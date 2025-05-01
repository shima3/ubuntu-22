#!/bin/bash
PACKAGE="chromium"

script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
base="${PWD##*/[0-9]?-}"
root="${PWD%/*/*}"
# osver="$(basename ${PWD%/*/*})"
osver="${root##*/}"

$root/base/bin/pull.sh
../10-xrdp/bin/pull.sh

list="$(docker ps --filter ancestor=$base -q)"
if [ "$list" != "" ]; then docker rm -f "$list"; fi

# tag="${OSVersion%%.*}$Architecture"

if ! docker build --tag "test:$base" --target test-stage --build-arg "PACKAGE=$PACKAGE" context; then exit 1; fi

if ! docker build --tag "pkg:$base" --target package-stage --build-arg "PACKAGE=$PACKAGE" --label "OS-Ver=$osver" context; then exit 1; fi

# docker-remove-nameless-images
