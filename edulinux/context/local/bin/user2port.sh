#!/bin/bash
cmd="user2port --default-port=9 --offset=30000"
if [ "$*" == "" ]
then exec $cmd --update-interval=60 --table-size=512
fi
printf "%s\n" "$@" | $cmd
