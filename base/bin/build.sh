#!/bin/bash
package="\
  dconf-editor dnsutils dpkg-dev \
  file findutils \
  iputils-ping iproute2 \
  less lsb-release
  man-db \
  nano net-tools netcat-openbsd
  pwgen \
  rsnapshot \
  shc \
  traceroute \
  "
PACKAGE="\
  apt-file apt-transport-https apt-utils autoconf \
  bash build-essential \
  coreutils curl \
  dpkg-dev \
  git \
  libarchive-tools libtool \
  snapd software-properties-common sudo supervisor \
  wget \
  xz-utils \
  "

# python3-pip

script="$(readlink -f $0)"
# cd "${0%/*}/.."
bin="${script%/*}"
cd "$bin/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*})"

img="${osver/-/:}.04"
docker pull "$img"
docker tag "$img" ubuntu

# docker build --tag "$base" --build-arg "PACKAGE=$PACKAGE" --label "OS-Ver=$osver" --file Dockerfile context
docker build --tag "$base" --build-arg "PACKAGE=$PACKAGE" --label "OS-Ver=$osver" context
# docker-remove-nameless-images
