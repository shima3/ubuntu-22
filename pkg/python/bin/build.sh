#!/bin/bash
PACKAGE="\
  python3 python3-dev python3-pip python3-tk \
  libavformat-dev libfreetype6-dev libjpeg-dev \
  libportmidi-dev \
  libsdl1.2-dev libsdl-image1.2-dev libsdl-mixer1.2-dev libsdl-ttf2.0-dev \
  libsmpeg-dev libswscale-dev \
  "

bin="${0%/*}"
cd "$bin/.."
base="${PWD##*/}"
osver="$(basename ${PWD%/*/*})"

list=`docker ps -q -f status=exited; docker ps -q -f status=created`
if [ "$list" != "" ]; then docker rm $list; fi
list="$(docker images -f dangling=true -q)"
if [ "$list" != "" ]; then docker rmi $list; fi

function inspect_created(){
    docker inspect $1 --format '{{.Created}}' 2> /dev/null
}
function pkg_pull(){
    remote="kshima/pkg_$1:$tag"
    docker pull $remote
    remote_created="$(inspect_created $remote)"
    local="pkg_$1"
    local_created="$(inspect_created $local)"
    if [[ "$remote_created" > "$local_created" ]]; then
        echo "Pull: $remote > $local"
        docker tag "$remote" "$local"
    else
        echo "Skip: $remote <= $local"
    fi
}
# for pkg in $(awk '/^COPY --from=pkg_/{ print substr($2, 12); }' Dockerfile); do pkg_pull $pkg; done

if ! docker build --build-arg "PACKAGE=$PACKAGE" --tag "test:$base" --target test-stage context; then exit 1; fi
if ! docker build --build-arg "PACKAGE=$PACKAGE" --tag "pkg:$base" --target package-stage --label "OS-Ver=$osver" context; then exit 1; fi
# if ! docker build --tag "test:$base" trash; then exit 1; fi
