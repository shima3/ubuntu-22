#!/bin/bash
Architecture="$(docker info --format '{{.Architecture}}')"
repo="kshima/latex:ubuntu24$Architecture"
docker run -it --rm -v "/Users:/Users" -w "$PWD" "$repo" pdffonts $*
