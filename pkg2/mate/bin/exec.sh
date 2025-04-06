#!/bin/bash
# TZ=Asia/Tokyo
# bin="$(dirname $0)"
# cd "$bin/.."
cd "${0%/*}/.."
# base="$(basename $PWD)"
base="${PWD##*/}"

docker exec -it "$base" bash
