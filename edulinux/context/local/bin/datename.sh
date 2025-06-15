#!/bin/bash
for name in $*
do
    if [ -e $name ]
    then
	time="$(date -r $name +%Y%m%d%H%M%S)"
	echo "rename $name -> $name@$time"
	mv $name $name@$time
    fi
done
