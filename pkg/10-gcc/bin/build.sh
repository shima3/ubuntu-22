#!/bin/bash
PACKAGE="gcc g++ libmpfr6 libgmp10 libmpfr-dev libgmp-dev pkg-config libsecp256k1-dev zlib1g-dev cmake llvm-15 clang-15 lld-15 llvm-15-tools libboost-all-dev libfmt-dev libyaml-dev libjemalloc-dev xxd bison flex"

script="$(readlink -f $0)"
bin="${script%/*}"
# cd "${0%/*}/.."
cd "$bin/.."
# base="${PWD##*/}"
base="${PWD##*/[0-9]?-}"
root="${PWD%/*/*}"
osver="${root##*/}"

$root/base/bin/pull.sh

if ! docker build --build-arg "PACKAGE=$PACKAGE" --tag "test:$base" --target test-stage .; then exit 1; fi

if ! docker build --build-arg "PACKAGE=$PACKAGE" --tag "pkg:$base" --target package-stage --label "OS-Ver=$osver" .; then exit 1; fi
