#!/bin/bash
echo LANG="$LANG" > /etc/default/locale
ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime
echo "$TZ" > /etc/timezone
bin="$(dirname $0)"
for starter in $(ls $bin/start-*.sh)
do $starter
done
sleep infinity
