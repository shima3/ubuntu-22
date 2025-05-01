#!/bin/bash
script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
base="${PWD##*/[0-9]?-}"
root="${PWD%/*/*}"
# osver="$(basename ${PWD%/*/*})"
osver="${root##*/}"

$root/base/bin/pull.sh
../10-xrdp/bin/pull.sh

# Architecture="$(docker inspect --format '{{.Architecture}}' ubuntu:latest)"

list="$(docker ps --filter ancestor=$base -q)"
if [ "$list" != "" ]; then docker rm -f "$list"; fi

# cd context
# rm vscode.deb
# ln -s code_*_${Architecture}.deb vscode.deb
# cd ..

if ! docker build --tag "test:$base" --target test-stage -f Dockerfile context; then exit 1; fi
if ! docker build --tag "pkg:$base" --target package-stage --label "OS-Ver=$osver" -f Dockerfile context; then exit 1; fi
