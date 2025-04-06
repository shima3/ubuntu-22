#!/bin/bash
PACKAGE="\
  apt-file apt-transport-https autoconf \
  bash build-essential \
  coreutils curl \
  dconf-editor dnsutils dpkg-dev \
  file findutils \
  git \
  iputils-ping iproute2 \
  less libtool lsb-release \
  man-db \
  nano net-tools netcat-openbsd \
  pwgen \
  rsnapshot \
  shc snapd sudo supervisor software-properties-common \
  traceroute \
  wget \
  xz-utils \
  "

# bin="$(dirname $0)"
# cd "$bin/.."
cd "${0%/*}/.."
# base="$(basename $PWD)"
base="${PWD##*/}"
osver="$(basename ${PWD%/*})"

img="${osver/-/:}.04"
docker pull "$img"
docker tag "$img" ubuntu

# docker build --tag "$base" --build-arg "PACKAGE=$PACKAGE" --label "OS-Ver=$osver" --file Dockerfile context
docker build --tag "$base" --build-arg "PACKAGE=$PACKAGE" --label "OS-Ver=$osver" context
# docker-remove-nameless-images
