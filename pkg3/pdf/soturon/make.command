#!/bin/bash
cd "$(dirname $0)"
# if docker run --rm -v "/Users:/Users" -w "$PWD" \
#           kshima/texlive-ubuntu:2019-20.04 \
#           /root/tex2pdf.sh paper
if ./run-tex2pdf.sh paper
then open paper.pdf
fi
