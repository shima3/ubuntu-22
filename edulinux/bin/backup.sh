#!/bin/bash
script="$(readlink -f $0)"
bin="${script%/*}"
cd "$bin/.."
base="$(basename $PWD)"
date="$(date +%Y%m%d)"

time docker export "$base" --output "$base-$date.tar"
