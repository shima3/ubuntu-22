#!/bin/bash
# cd
# cat >> log.txt
# printenv >> /tmp/log.txt
IFS=$'\n' data=($(awk 'NR==1{print $2;}/^From: /{print substr($0, 7);}' | nkf))
email="${data[0]}"
name="${data[1]% <*}"
domain="${email#*@}"
if [ "$domain" == "e.hiroshima-cu.ac.jp" -o "$domain" == "hiroshima-cu.ac.jp" ]
then
  user="${email%@*}"
  password="$(docker exec edulinux reset-password.sh $user)"
  echo "New password: $password" | mail -s "reset password for the user $user on edulinux" "$email"
  docker exec edulinux usermod --comment "$name" "$user"
  echo "$name" | docker exec --interactive edulinux su --command "config-git.sh $email" "$user"
fi
exit 0
