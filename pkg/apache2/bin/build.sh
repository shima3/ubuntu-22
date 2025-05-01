#!/bin/bash
PACKAGE="apache2 php certbot python3-certbot-apache"

cd "${0%/*}/.."
base="${PWD##*/}"
root="${PWD%/*/*}"
# osver="$(basename ${PWD%/*/*})"
osver="${root##*/}"

$root/base/bin/pull.sh

if ! docker build --tag "test:$base" --target test-stage --build-arg "PACKAGE=$PACKAGE" --file Dockerfile context; then exit 1; fi

if ! docker build --tag "pkg:$base" --build-arg "PACKAGE=$PACKAGE" --target package-stage --label "OS-Ver=$osver" --file Dockerfile context; then exit 1; fi
