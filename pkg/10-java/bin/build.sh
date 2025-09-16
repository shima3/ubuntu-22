#!/bin/bash
# PACKAGE="openjdk-8-jdk openjdk-17-jdk libmpfr6 libgmp10 libmpfr-dev libgmp-dev"
PACKAGE="openjdk-8-jdk openjdk-17-jdk maven"

script="$(readlink -f $0)"
bin="${script%/*}"
# cd "${0%/*}/.."
cd "$bin/.."
# base="${PWD##*/}"
base="${PWD##*/[0-9]?-}"
root="${PWD%/*/*}"
osver="${root##*/}"

$root/base/bin/pull.sh

list="$(docker ps --filter ancestor=$base -q)"
if [ "$list" != "" ]; then docker rm -f "$list"; fi

if ! docker build --tag "test:$base" --target test-stage --build-arg "PACKAGE=$PACKAGE" context; then exit 1; fi
if ! docker build --tag "pkg:$base" --target package-stage --build-arg "PACKAGE=$PACKAGE" --label "OS-Ver=$osver" context; then exit 1; fi
