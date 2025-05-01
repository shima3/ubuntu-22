#!/bin/bash
PACKAGE="emacs"

script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
base="${PWD##*/[0-9]?-}"
root="${PWD%/*/*}"
osver="${root##*/}"

$root/base/bin/pull.sh
../10-xrdp/bin/pull.sh

# docker images ubuntu > /dev/null
# OSVersion="$(docker inspect --format '{{json .Config.Labels}}' --type=image ubuntu:latest | jq --raw-output --join-output '.["org.opencontainers.image.ref.name"], .["org.opencontainers.image.version"]')"
# Architecture="$(docker inspect --format '{{.Architecture}}' --type=image ubuntu:latest)"
# if [ "$OSVersion" == "" -o "$Architecture" == "" ]; then echo "Try again"; exit 1; fi

# tag="${OSVersion%%.*}$Architecture"

list="$(docker ps --filter ancestor=$base -q)"
if [ "$list" != "" ]; then docker rm -f "$list"; fi

if ! docker build --tag "test:$base" --build-arg "PACKAGE=$PACKAGE" context; then exit 1; fi
# if ! docker build --tag "pkg:$base" --target package-stage --build-arg "PACKAGE=$PACKAGE" --label "OSVersion=$OSVersion" context; then exit 1; fi
if ! docker build --tag "pkg:$base" --target package-stage --build-arg "PACKAGE=$PACKAGE" --label "OSVersion=${osver/-/:}.04" context; then exit 1; fi
