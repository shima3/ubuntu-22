#!/bin/bash
PACKAGE="mate-desktop-environment ubuntu-mate-desktop"

script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
base="${PWD##*/[0-9]?-}"
root="${PWD%/*/*}"
# osver="$(basename ${PWD%/*/*})"
osver="${root##*/}"

$root/base/bin/pull.sh
../10-xrdp/bin/pull.sh

docker build --tag "pkg:$base" --target package-stage --build-arg "PACKAGE=$PACKAGE" --label "OS-Ver=$osver" -f Dockerfile context

list="$(docker ps --filter ancestor=test:$base -q)"
if [ "$list" != "" ]; then docker rm -f "$list"; fi
docker build --tag "test:$base" --target test-stage --build-arg "PACKAGE=$PACKAGE" --label "OS-Ver=$osver" -f Dockerfile context

echo -e "\a\a\a"
