#!/bin/bash
PACKAGE="\
    alsa-utils \
    dbus dbus-x11 \
    libpulse-dev \
    pulseaudio pulseaudio-utils \
    xauth xdotool xorg xorgxrdp xrdp xserver-xorg \
    "

script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
base="${PWD##*/[0-9]?-}"
root="${PWD%/*/*}"
# osver="$(basename ${PWD%/*/*})"
osver="${root##*/}"

$root/base/bin/pull.sh

docker build --tag "test:$base" --target test-stage --build-arg "PACKAGE=$PACKAGE" --label "OS-Ver=$osver" --file Dockerfile context

docker build --tag "pkg:$base" --target package-stage --build-arg "PACKAGE=$PACKAGE" --label "OS-Ver=$osver" --file Dockerfile context
