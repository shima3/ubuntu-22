#!/bin/bash
PACKAGE="openjdk-8-jdk"

cd "${0%/*}/.."
base="${PWD##*/}"
root="${PWD%/*/*}"
# osver="$(basename ${PWD%/*/*})"
osver="${root##*/}"

$root/base/bin/pull.sh

list="$(docker ps --filter ancestor=$base -q)"
if [ "$list" != "" ]; then docker rm -f "$list"; fi

if ! docker build --tag "test:$base" --target test-stage --build-arg "PACKAGE=$PACKAGE" context; then exit 1; fi
if ! docker build --tag "pkg:$base" --target package-stage --build-arg "PACKAGE=$PACKAGE" --label "OS-Ver=$osver" context; then exit 1; fi
