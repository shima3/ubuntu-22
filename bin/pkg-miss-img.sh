#!/bin/bash
cd "${0%/*}/../pkg"
for dir in [0-9]?-*
do
    pkg="${dir#[0-9]?-}"
    if ! docker inspect --type=image "pkg:$pkg" > /dev/null 2>&1
    then echo $dir
    fi
done
