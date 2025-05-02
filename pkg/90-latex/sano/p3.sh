#!/bin/bash
Architecture="$(docker info --format '{{.Architecture}}')"
UbuntuVersion="$(docker inspect --format '{{json .Config.Labels}}' ubuntu | jq --raw-output '.["org.opencontainers.image.version"]')"
os_version="ubuntu${UbuntuVersion%%.*}"
repo="kshima/latex:$os_version$Architecture"
# time docker pull "$repo"
if docker run --rm -v "/Users:/Users" -w "$PWD" -it "$repo" tex2pdf.sh paper
then
    if [ "$TERM_PROGRAM" != "" ]
    then open paper.pdf
    fi
fi
