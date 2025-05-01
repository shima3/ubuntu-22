#!/bin/bash
PACKAGE="gcc g++"

cd "${0%/*}/.."
base="${PWD##*/}"
root="${PWD%/*/*}"
# osver="$(basename ${PWD%/*/*})"
osver="${root##*/}"

$root/base/bin/pull.sh

if ! docker build --build-arg "PACKAGE=$PACKAGE" --tag "test:$base" --target test-stage .; then exit 1; fi

if ! docker build --build-arg "PACKAGE=$PACKAGE" --tag "pkg:$base" --target package-stage --label "OS-Ver=$osver" .; then exit 1; fi
