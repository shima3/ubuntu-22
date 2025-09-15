#!/bin/bash
bin="$(dirname $0)"
cd "$bin/.."
base="${PWD##*/[0-9]?-}"

docker-remove-containers-not-running

docker run --name "$base" --hostname "$base" -e "LC_ALL=ja_JP.UTF-8" -it --rm "test:$base" bash
