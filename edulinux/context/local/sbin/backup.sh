#!/bin/bash
day="$(date +%F)"
for file in /etc /home /opt /root /usr /var
do
    if [[ "$file" == */ ]]
    then dir="/"
    else
        dir="$(dirname $file)"
        base="$(basename $file)"
        if [[ "$dir" == "." ]]; then dir=""; fi
        if [[ "$dir" != /* ]]; then dir="/$dir"; fi
    fi
    dest="/backup/$day$dir"
    mkdir -p "$dest"
    rsync --archive --delete --link-dest="/backup/daily.0$dir" --exclude='.cache' --exclude='.thinclient_drives' "$file" "$dest"
done
