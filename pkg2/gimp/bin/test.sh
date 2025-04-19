#!/bin/bash
bin="${0%/*}"
cd "$bin/.."
base="${PWD##*/}"

<<<<<<< Updated upstream
if ! docker build --tag "test:$base" trash; then exit 1; fi

=======
>>>>>>> Stashed changes
# docker run -it --rm -p 3333:3389 "test:$base" bash -c 'useradd -m -s /bin/bash student; echo student:1883shima | chpasswd; /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf'
docker run -it --rm -p 3333:3389 "test:$base"
