#!/bin/bash
cd "${0%/*}/../pkg"
for dir in [0-9]?-*
do
    echo "----- $dir -----"
    cd $dir
    $*
    cd - > /dev/null
done
