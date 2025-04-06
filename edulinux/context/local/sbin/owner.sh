#!/bin/bash
if [ "$*" != "" ]; then
    # stat -c "%U" "$@"
    printf '%s\n' "$@" | $0
    exit $?
fi
while read -r line; do
    stat -c '%U' "$line"
done
exit $?
