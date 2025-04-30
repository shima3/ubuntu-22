#!/bin/bash
PACKAGE="\
  dconf-editor dnsutils dpkg-dev \
  file findutils \
  iputils-ping iproute2 \
  less lsb-release \
  man-db \
  nano net-tools netcat-openbsd \
  pwgen \
  rsnapshot \
  shc \
  traceroute \
  "

script="$(readlink -f $0)"
# cd "${0%/*}/.."
bin="${script%/*}"
cd "$bin/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*})"

# img="${osver/-/:}.04"
# docker pull "$img"
# docker tag "$img" ubuntu

# docker build --tag "$base" --build-arg "PACKAGE=$PACKAGE" --label "OS-Ver=$osver" context
if ! docker build --tag "pkg:$base" --target package-stage --build-arg "PACKAGE=$PACKAGE" --label "OS-Ver=$osver" context; then exit 1; fi
