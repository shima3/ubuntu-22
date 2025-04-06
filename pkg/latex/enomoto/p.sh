#!/bin/bash
# docker run --rm -v "/Users:/Users" -w "$PWD" kshima/texlive2017-emacs25-ubuntu18 tex2pdf.sh paper
if docker run --rm -v "/Users:/Users" -w "$PWD" kshima/texlive2017-emacs25-ubuntu18 platex paper
then if docker run --rm -v "/Users:/Users" -w "$PWD" kshima/texlive2017-emacs25-ubuntu18 dvipdfmx paper
     then open paper.pdf
     fi
fi
