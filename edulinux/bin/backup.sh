#!/bin/bash
script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
base="$(basename $PWD)"
date="$(date +%Y%m%d)"

# docker exportではマウントしたボリュームが保存されない。
# docker export "$base" --output "$base-$date.tar"

time docker cp --archive "$base:." - > "$base-$date.tar"
