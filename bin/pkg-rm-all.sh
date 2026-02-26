#!/bin/bash
cd "${0%/*}/../pkg"
for dir in [0-9]?-*
do
    pkg="${dir#[0-9]?-}"
    echo "--- rm $dir ---"
    docker image rm pkg:$pkg test:$pkg
done
