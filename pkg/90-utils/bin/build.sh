#!/bin/bash
PACKAGE="\
  dconf-editor dnsutils dpkg-dev \
  file findutils \
  iputils-ping iproute2 \
  less lsb-release lsof \
  man-db \
  nano net-tools netcat-openbsd \
  pwgen \
  rsnapshot \
  shc \
  traceroute \
  "

script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
# base="${PWD##*/}"
base="${PWD##*/[0-9]?-}"
root="${PWD%/*/*}"
osver="${root##*/}"

$root/base/bin/pull.sh

if ! docker build --tag "pkg:$base" --target package-stage --build-arg "PACKAGE=$PACKAGE" --label "OS-Ver=$osver" context; then exit 1; fi
