#!/bin/bash
cd "${0%/*}/../pkg"
for dir in [0-9]?-*
do
    echo "--- build $dir ---"
    $dir/bin/build.sh
done
