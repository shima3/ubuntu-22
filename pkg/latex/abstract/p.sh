#!/bin/bash
Architecture="$(docker info --format '{{.Architecture}}')"
repo="kshima/latex:ubuntu24$Architecture"
docker run --rm -v "/Users:/Users" -w "$PWD" -it "$repo" tex2pdf.sh paper
# docker run --rm -v "/Users:/Users" -w "$PWD" kshima/texlive2017-emacs25-ubuntu18 tex2pdf.sh paper
