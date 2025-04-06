#!/bin/bash
args="$*"
while read -r line; do
    set -- $line
    eval echo "$args"
done
# Example$ ls /home | filter.sh '/home/$1/P3R7' | filter.sh '${1%/*}'
