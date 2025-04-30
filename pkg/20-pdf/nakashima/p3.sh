#!/bin/bash
Architecture="$(docker info --format '{{.Architecture}}')"
# repo="kshima/latex:ubuntu18$Architecture"
repo="kshima/latex:ubuntu24$Architecture"
# time docker pull "$repo"
if docker run --rm -v "/Users:/Users" -w "$PWD" -it "$repo" tex2pdf.sh paper
then
    if [ "$TERM_PROGRAM" != "" ]
    then open paper.pdf
    fi
    # docker run --rm -v "/Users:/Users" -w "$PWD" -it "$repo" pdffonts paper.pdf
fi
