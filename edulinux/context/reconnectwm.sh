#!/usr/bin/env bash
export LC_ALL=ja_JP.UTF-8
dir="$HOME/.local/share/xrdp"
log="$dir/reconnect.log"
mkdir -p "$dir"
time="$(date -Iminutes)"
echo -e "$time reconnect\t$DISPLAY" >> "$log"
zenity --warning --text="ログアウト忘れを検知しました\n前回、ログアウトせずにウィンドウを閉じたようです。\nログアウトせず放置するとサーバの記憶容量を圧迫します。\n作業終了時は右上の電源マーク⏻からログアウトしてください。" 2>> "$log"
time="$(date -Iminutes)"
echo -e "$time Warning\tOK" >> "$log"
