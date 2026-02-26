#!/bin/bash
script="$(readlink -f $0)"
# bin="${0%/*}"
bin="${script%/*}"
cd "$bin/.."
# base="${PWD##*/}"
base="${PWD##*/[0-9]?-}"
root="${PWD%/*/*}"
osver="${root##*/}"

$root/base/bin/pull.sh

list=`docker ps -q -f status=exited; docker ps -q -f status=created`
if [ "$list" != "" ]; then docker rm $list; fi
list="$(docker images -f dangling=true -q)"
if [ "$list" != "" ]; then docker rmi $list; fi

if ! docker build --tag "test:$base" --target test-stage context; then exit 1; fi
if ! docker build --tag "pkg:$base" --target package-stage --label "OS-Ver=$osver" context; then exit 1; fi
