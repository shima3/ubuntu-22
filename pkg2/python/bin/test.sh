#!/bin/bash
bin="${0%/*}"
cd "$bin/.."
base="${PWD##*/}"

# if ! docker build --tag "test:$base" trash; then exit 1; fi
# if ! docker build --build-arg "PACKAGE=$PACKAGE" --tag "test:$base" --target test-stage context; then exit 1; fi

# docker run -it --rm -p 3333:3389 "test:$base" bash -c 'useradd -m -s /bin/bash student; echo student:1883shima | chpasswd; /usr/bin/supervisord -nc /etc/supervisor/supervisord.conf'
docker run -it --rm -p 3333:3389 "test:$base" bash
