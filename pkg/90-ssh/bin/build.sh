#!/bin/bash
PACKAGE="openssh-server"

script="$(readlink -f $0)"
bin="${script%/*}"
# cd "${0%/*}/.."
cd "$bin/.."
# base="${PWD##*/}"
base="${PWD##*/[0-9]?-}"
root="${PWD%/*/*}"
osver="${root##*/}"

$root/base/bin/pull.sh

if ! docker build --tag "test:$base" --target test-stage --build-arg "PACKAGE=$PACKAGE" --file Dockerfile context; then exit 1; fi
if ! docker build --tag "pkg:$base" --target package-stage --build-arg "PACKAGE=$PACKAGE" --label "OS-Ver=$osver" --file Dockerfile context; then exit 1; fi
