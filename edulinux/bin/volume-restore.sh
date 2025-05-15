#!/bin/bash
script="$(readlink -f $0)"
dir="${script%/*/*}"
base="${dir##*/}"

docker volume rm "$base-etc"
docker run --rm --mount "type=volume,src=$base-etc,dst=/volume" --mount "type=bind,src=$PWD,dst=/backup" base tar Jxf /backup/$base-etc.tar.xz -C /volume

docker volume rm "$base-home"
docker run --rm --mount "type=volume,src=$base-home,dst=/volume" --mount "type=bind,src=$PWD,dst=/backup" base tar Jxf /backup/$base-home.tar.xz -C /volume
