#!/bin/bash
# bin="$(dirname $0)"
# cd "$bin/.."
cd "${0%/*}/.."
base="${PWD##*/}"
# osver="$(basename ${PWD%/*})"

bin/_run.sh \
    -dit \
    "$base"

#       --name "$base" --hostname "$base" \
#       -p "$xrdp_port:3389" \
#       -p "$http_port:80" \
#       --device /dev/fuse --cap-add SYS_ADMIN \

# docker exec "$base" useradd -g users -m -s /bin/bash student
# echo 'student:1883shima' | docker exec -i "$base" chpasswd
docker exec "$base" reset-password.sh student 1883shima
echo 'Shima Group Student' | docker exec --interactive --user student "$base" config-git.sh shima@hiroshima-cu.ac.jp

docker exec "$base" useradd -g users -m -s /bin/bash shima
echo 'shima:18830743' | docker exec -i "$base" chpasswd

docker exec "$base" bash -c 'while ! ss -tln | grep -q :3389; do echo wait; sleep 1; done'
echo OK
