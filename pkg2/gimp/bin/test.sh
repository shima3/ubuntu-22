#!/bin/bash
bin="${0%/*}"
cd "$bin/.."
base="${PWD##*/}"

# docker run -it --rm -p 3333:3389 "test:$base" bash -c 'useradd -m -s /bin/bash student; echo student:1883shima | chpasswd; /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf'
docker run -it --rm -p 3333:3389 "test:$base"
