#!/bin/bash
script="$(readlink -f $0)"
# cd "${0%/*}/.."
bin="${script%/*}"
cd "$bin/.."
base="${PWD##*/}"

bin/_run.sh \
    -dit \
    --name test \
    "$base"

#    -v $PWD/context/local/bin:/usr/local/bin \
#       --name "$base" --hostname "$base" \
#       -p "$xrdp_port:3389" \
#       -p "$http_port:80" \
#       --device /dev/fuse --cap-add SYS_ADMIN \

# docker exec "$base" useradd -g users -m -s /bin/bash student
# docker exec "$base" reset-password.sh guest guest
# echo 'Guest' | docker exec --interactive --user guest "$base" config-git.sh guest@e.hiroshima-cu.ac.jp

user=a20999
# bin/exec.sh useradd -g users -m -s /bin/bash "$user"
bin/exec.sh useradd -g users -m -s /bin/bash "$user"
bin/exec.sh usermod --password '$y$j9T$C5nrs3yRKRbxWJbXQDE17/$T4k4l0PZtaJOVk.9gvuJsFXJOBX4esUbbkqWGq1XVeD' "$user"

list="$(docker ps --all --filter ancestor=$base --quiet)"
echo '"| cat > $HOME/lastmail.txt"' | docker exec -i $list dd of=/home/a20999/.forward

# bin/exec.sh useradd -g sudo -m -s /bin/bash shima
# bin/exec.sh usermod --password '$y$j9T$whNZTgxbGdeIJuWEUSkJA0$0fr5b1BLfAbV4qd8GMzM8JOg5vle2spWcuUI3xW9jCD' shima
