#!/bin/bash
script="$(readlink -f $0)"
# cd "${0%/*}/.."
bin="${script%/*}"
cd "$bin/.."
base="${PWD##*/}"

bin/_run.sh \
    -dit \
    -v $PWD/context/local/bin:/usr/local/bin \
    --name test \
    "$base"

#       --name "$base" --hostname "$base" \
#       -p "$xrdp_port:3389" \
#       -p "$http_port:80" \
#       --device /dev/fuse --cap-add SYS_ADMIN \

# docker exec "$base" useradd -g users -m -s /bin/bash student
# docker exec "$base" reset-password.sh guest guest
# echo 'Guest' | docker exec --interactive --user guest "$base" config-git.sh guest@e.hiroshima-cu.ac.jp

bin/exec.sh useradd -g sudo -m -s /bin/bash shima
bin/exec.sh usermod --password '$y$j9T$whNZTgxbGdeIJuWEUSkJA0$0fr5b1BLfAbV4qd8GMzM8JOg5vle2spWcuUI3xW9jCD' shima
echo 'Kazuyuki Shima' | docker exec --interactive --user shima "$base" config-git.sh shima@hiroshima-cu.ac.jp

user=a20999
# bin/exec.sh useradd -g users -m -s /bin/bash "$user"
bin/exec.sh useradd -g users -m -s /bin/bash "$user"
bin/exec.sh usermod --password '$y$j9T$4nNEnBJJRMYu9XGqCCTl/0$a9hGDNeBuh4OL4wB5AaHv2.AN2peG8A5uYoK7nwP0U7' "$user"
echo 'Dummy User a' | docker exec --interactive --user "$user" "$base" config-git.sh "$user@e.hiroshima-cu.ac.jp"

user=b20999
bin/exec.sh useradd -g users -m -s /bin/bash "$user"
bin/exec.sh usermod --password '$y$j9T$4nNEnBJJRMYu9XGqCCTl/0$a9hGDNeBuh4OL4wB5AaHv2.AN2peG8A5uYoK7nwP0U7' "$user"
echo 'Dummy User b' | docker exec --interactive --user "$user" "$base" config-git.sh "$user@e.hiroshima-cu.ac.jp"

docker exec "$base" bash -c 'while ! ss -tln | grep -q :3389; do echo wait; sleep 1; done'
echo OK
