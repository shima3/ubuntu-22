#!/bin/bash
PACKAGE="\
  pdftk poppler-utils printer-driver-cups-pdf \
  xpdf \
  "

script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
base="${PWD##*/[0-9]?-}"
root="${PWD%/*/*}"
# osver="$(basename ${PWD%/*/*})"
osver="${root##*/}"

$root/base/bin/pull.sh
../10-xrdp/bin/pull.sh

if ! docker build --build-arg "PACKAGE=$PACKAGE" --tag "test:$base" --target test-stage -f Dockerfile context; then exit 1; fi
if ! docker build --build-arg "PACKAGE=$PACKAGE" --tag "pkg:$base" --target package-stage --label "OS-Ver=$osver" -f Dockerfile context; then exit 1; fi
