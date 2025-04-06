#!/bin/bash
docker run --rm -v "/Users:/Users" -w "$PWD" kshima/texlive2017-emacs25-ubuntu18 tex2pdf.sh paper
