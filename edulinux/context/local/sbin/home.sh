#!/bin/bash
if [ "$*" != "" ]; then
    # getent passwd "$@" | cut -d: -f6
    printf '%s\n' "$@" | $0
    exit $?
fi
while read -r line; do
    getent passwd "$line" | cut -d: -f6
done
exit $?
