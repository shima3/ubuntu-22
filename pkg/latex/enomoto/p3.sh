#!/bin/bash
Architecture="$(docker info --format '{{.Architecture}}')"
repo="kshima/latex:ubuntu24$Architecture"
if time docker run --rm -v "/Users:/Users" -w "$PWD" -it "$repo" tex2pdf.sh paper
then
    open paper.pdf
    docker run --rm -v "/Users:/Users" -w "$PWD" -it "$repo" pdffonts paper.pdf
fi
