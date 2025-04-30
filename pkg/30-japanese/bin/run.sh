#!/bin/bash
bin="$(dirname $0)"
cd $bin/..
base="$(basename $PWD)"

docker run --rm --name $base -it $base
