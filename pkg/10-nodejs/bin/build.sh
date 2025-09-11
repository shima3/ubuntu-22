#!/bin/bash
# PACKAGE="apt-transport-https ca-certificates curl gnupg nodejs"
# PACKAGE="gnupg nodejs"

script="$(readlink -f $0)"
bin="${script%/*}"
# cd "${0%/*}/.."
cd "$bin/.."
# base="${PWD##*/}"
base="${PWD##*/[0-9]?-}"
root="${PWD%/*/*}"
osver="${root##*/}"

$root/base/bin/pull.sh

# if ! docker build --tag "test:$base" --target test-stage --build-arg "PACKAGE=$PACKAGE" --file Dockerfile context; then exit 1; fi
if ! docker build --tag "test:$base" --target test-stage .; then exit 1; fi

if ! docker build --tag "pkg:$base" --target package-stage --label "OS-Ver=$osver" .; then exit 1; fi
