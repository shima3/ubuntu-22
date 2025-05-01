#!/bin/bash
PACKAGE="\
  texlive \
  texlive-latex-recommended texlive-latex-extra \
  texlive-fonts-recommended texlive-bibtex-extra \
  texlive-lang-japanese \
  perl-tk \
  "

cd "${0%/*}/.."
base="${PWD##*/}"
root="${PWD%/*/*}"
# osver="$(basename ${PWD%/*/*})"
osver="${root##*/}"

$root/base/bin/pull.sh

if ! docker build --build-arg "PACKAGE=$PACKAGE" --tag "test:$base" --target test-stage -f Dockerfile context; then exit 1; fi
if ! docker build --build-arg "PACKAGE=$PACKAGE" --tag "pkg:$base" --target package-stage --label "OS-Ver=$osver" -f Dockerfile context; then exit 1; fi
