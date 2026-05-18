#!/bin/bash
PACKAGE="\
  python3 python3-dev python3-pip python3-tk python3-pil.imagetk \
  libavformat-dev libfreetype6-dev libjpeg-dev \
  libportmidi-dev \
  libsdl1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libsdl-ttf2.0-dev \
  libsmpeg-dev libswscale-dev \
  "

script="$(readlink -f $0)"
# bin="${0%/*}"
bin="${script%/*}"
cd "$bin/.."
# base="${PWD##*/}"
base="${PWD##*/[0-9]?-}"
root="${PWD%/*/*}"
osver="${root##*/}"

$root/base/bin/pull.sh

list=`docker ps -q -f status=exited; docker ps -q -f status=created`
if [ "$list" != "" ]; then docker rm $list; fi
list="$(docker images -f dangling=true -q)"
if [ "$list" != "" ]; then docker rmi $list; fi

if ! docker build --build-arg "PACKAGE=$PACKAGE" --tag "test:$base" --target test-stage context; then exit 1; fi
if ! docker build --build-arg "PACKAGE=$PACKAGE" --tag "pkg:$base" --target package-stage --label "OS-Ver=$osver" context; then exit 1; fi
