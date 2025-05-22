#!/bin/bash
user="a20999"
password="18830743"
name="Dummy User"
docker exec edulinux reset-password.sh "$user" "$password"
docker exec edulinux usermod --comment "$name" "$user"
echo "$name" | docker exec --interactive edulinux su --command "config-git.sh $email" "$user"
