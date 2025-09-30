#!/bin/bash
script="$(readlink -f $0)"
dir="${script%/*/*}"
base="${dir##*/}"
etctar="/home/.etc.tar"

# docker run --rm --mount "type=volume,src=$base-etc,dst=/volume" --mount "type=bind,src=$PWD,dst=/backup" base tar Jcf /backup/$base-etc.tar.xz -C /volume .

docker run --rm \
       --mount "type=volume,src=$base-etc,dst=/mnt/etc" \
       --mount "type=volume,src=$base-home,dst=/home" \
       base tar cf "$etctar" -C /mnt/etc passwd shadow group gshadow

docker run --rm \
       --mount "type=volume,src=$base-home,dst=/home" \
       --mount "type=bind,src=$PWD,dst=/backup" \
       base tar Jcf /backup/$base-home.tar.xz -C /home .
