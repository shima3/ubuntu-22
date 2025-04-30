exec docker run --rm -v "/Users:/Users" -w "$PWD" \
       kshima/texlive-ubuntu:2019-20.04 \
       /root/tex2pdf.sh $*
