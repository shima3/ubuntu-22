#!/bin/bash
# echo -n 'client_folder.sh: start at ' >> /tmp/a.log
# date >> /tmp/a.log
target_dir="$HOME/.thinclient_drives"
link_name="$HOME/デスクトップ/MyPC"
if [ -L "$link_name" ]; then
    rm "$link_name"
fi
sleep 1
# echo -n 'client_folder.sh: link at ' >> /tmp/a.log
# date >> /tmp/a.log
if [ "$(ls $target_dir)" != "" ]; then
    ln -s "$target_dir" "$link_name"
fi
# echo -n 'client_folder.sh: end at ' >> /tmp/a.log
# date >> /tmp/a.log
