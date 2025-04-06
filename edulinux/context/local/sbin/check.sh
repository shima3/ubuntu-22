#!/bin/bash
args="$*"
while read -r line; do
    set -- $line
    eval $args && echo "$line"
done
# Example$ ls /home | subst.sh '/home/$1/P3R7' | check.sh '[' -e '$1' ']'
