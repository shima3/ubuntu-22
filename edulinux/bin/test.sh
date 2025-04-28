#!/bin/bash
# bin="$(dirname $0)"
# cd "$bin/.."
cd "${0%/*}/.."
base="${PWD##*/}"
# osver="$(basename ${PWD%/*})"

bin/_run.sh \
    -dit \
    -v $PWD/context/local/bin:/usr/local/bin \
    "$base"

#       --name "$base" --hostname "$base" \
#       -p "$xrdp_port:3389" \
#       -p "$http_port:80" \
#       --device /dev/fuse --cap-add SYS_ADMIN \

# docker exec "$base" useradd -g users -m -s /bin/bash student
# echo 'student:1883shima' | docker exec -i "$base" chpasswd
docker exec "$base" reset-password.sh a20999 18830743
echo 'Dummy User' | docker exec --interactive --user a20999 "$base" config-git.sh a20999@e.hiroshima-cu.ac.jp

bin/exec.sh useradd -m -s /bin/bash shima
bin/exec.sh usermod --password '$y$j9T$whNZTgxbGdeIJuWEUSkJA0$0fr5b1BLfAbV4qd8GMzM8JOg5vle2spWcuUI3xW9jCD' shima
echo 'Kazuyuki Shima' | docker exec --interactive --user shima "$base" config-git.sh shima@hiroshima-cu.ac.jp

docker exec "$base" bash -c 'while ! ss -tln | grep -q :3389; do echo wait; sleep 1; done'
echo OK
