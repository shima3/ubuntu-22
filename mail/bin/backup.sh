#!/bin/bash
script="$(readlink -f $0)"
bin="${script%/*}"
# cd "$bin/.."
# base="$(basename $PWD)"
base="$(basename ${bin%/*})"
date="$(date +%Y%m%d)"

# docker exportではマウントしたボリュームが保存されない。
# docker export "$base" --output "$base-$date.tar"

backup="$base-$date.tar.xz"
echo "backup: $backup"
time docker cp --archive "$base:." - | xz > "$backup"
