#!/bin/bash
script="$(readlink -f $0)"
dir="${script%/*/*}"
base="${dir##*/}"

docker run --rm --mount "type=volume,src=$base-etc,dst=/volume" --mount "type=bind,src=$PWD,dst=/backup" base tar Jcf /backup/$base-etc.tar.xz -C /volume .
docker run --rm --mount "type=volume,src=$base-home,dst=/volume" --mount "type=bind,src=$PWD,dst=/backup" base tar Jcf /backup/$base-home.tar.xz -C /volume .
